require 'pry'

module BinarySearchTree
    class Node
        attr_accessor :value, :left_child, :right_child
        include Comparable

        def initialize(value, left_child=nil, right_child=nil)
            @value = value
            @left_child = left_child
            @right_child = right_child
        end

        def compare(node)
            self.value <=> node.value
        end

        def to_s
            print "(#{self.value})"
            ""
        end

        def leaf?
            !self.left_child && !self.right_child ? true : false
        end
    end

    class Tree
        attr_reader :root

        def initialize(array)
            @array = array.uniq.sort.map { |value| Node.new(value) }
            @root = build_tree(@array)
        end
        
        def build_tree(array=@array)
            return nil if array.length == 0
            return array[0] if array.length == 1
            root = array[array.length / 2]
            left_array = array[0..array.length / 2 - 1]
            right_array = array[array.length / 2 + 1..-1]
            
            root.left_child = build_tree(left_array)
            root.right_child = build_tree(right_array)
            root
        end

        def insert(value, root=self.root)
            
            if tree_includes?(value)
                duplicate_error_message
                return
            end

            smallest_node = self.level_order.sort_by { |n| n.value }[0]
            biggest_node = self.level_order.sort_by { |n| n.value }[-1]

            if value < smallest_node.value
                smallest_node.left_child = Node.new(value)
            end

            if value > biggest_node.value
                biggest_node.right_child = Node.new(value)
            end

            if value > smallest_node.value && value < biggest_node.value
                current_value = value

                until tree_includes?(current_value)
                    current_value += 1
                end

                parent = self.find(current_value)
                new_node = Node.new(value)
                new_node.left_child = parent.left_child
                parent.left_child = new_node
            end
        end

        def delete(value)
            if !tree_includes?(value)
                not_in_tree_error_message
                return
            end

            if value == self.root.value
                root_value_error_message
                return
            end

            node = find(value)
            parent = find_parent(value)

            if node.leaf?
                parent.left_child == node ? parent.left_child = nil : parent.right_child = nil
                return
            end

            if node.value < parent.value
                if !node.left_child && node.right_child
                    parent.left_child = node.right_child
                elsif !node.right_child && node.left_child
                    parent.left_child = node.left_child
                else
                    node_left_child = node.left_child
                    node_right_child = node.right_child
                    smallest_child = node_right_child

                    until smallest_child.leaf?
                        smallest_child = smallest_child.left_child
                    end

                    parent.left_child = node_right_child
                    smallest_child.left_child = node_left_child
                end
            end

            if node.value > parent.value
                if !node.left_child && node.right_child
                    parent.right_child = node.right_child
                elsif !node.right_child && node.left_child
                    parent.right_child = node.left_child
                else
                    node_left_child = node.left_child
                    node_right_child = node.right_child
                    smallest_child = node_left_child

                    until smallest_child.leaf?
                        smallest_child = smallest_child.left_child
                    end

                    parent.right_child = node_left_child
                    smallest_child.right_child = node_right_child
                end
            end
        end

        def find(value, root=self.root)
            return root if root.value == value
            return if root.leaf?
            
            if value < root.value && root.left_child
                return find(value, root.left_child)
            end

            if value > root.value && root.right_child
                return find(value, root.right_child)
            end
        end

        def level_order(queue=[self.root], ordered=[], &block)
            while !queue.empty?
                queue << queue[0].left_child if queue[0].left_child
                queue << queue[0].right_child if queue[0].right_child
                ordered << queue.shift
            end

            block_given? ? ordered.map { |n| yield(n) } : ordered
        end

        def preorder(&block)
            def get_nodes(root=self.root, ordered=[])
                if root.leaf?
                    ordered << root
                    return
                end

                ordered << root
                get_nodes(root.left_child, ordered) if root.left_child
                get_nodes(root.right_child, ordered) if root.right_child

                ordered
            end


            block_given? ? get_nodes.map { |n| yield(n) } : get_nodes
        end

        def inorder(&block)
            def get_nodes(root=self.root, ordered=[])
                if root.leaf?
                    ordered << root
                    return
                end

                get_nodes(root.left_child, ordered) if root.left_child
                ordered << root
                return ordered if root == self.root
                get_nodes(root.right_child, ordered) if root.right_child

                ordered
            end

            ordered = get_nodes + get_nodes(self.root.right_child)
            

            block_given? ? ordered.map { |n| yield(n) } : ordered
        end

        def postorder(&block)
            def get_nodes(root=self.root, ordered=[])
                if root.leaf?
                    ordered << root
                    return
                end

                get_nodes(root.left_child, ordered) if root.left_child
                get_nodes(root.right_child, ordered) if root.right_child
                ordered << root
                ordered
            end

            block_given? ? get_nodes.map { |n| yield(n) } : get_nodes
        end

        def depth(root, level_depth=0)
            current_node = root

            until current_node.leaf?
                if current_node.left_child
                    level_depth += 1
                    current_node = current_node.left_child
                    next
                end

                if current_node.right_child
                    level_depth += 1
                    current_node = current_node.right_child
                    next
                end
            end

            level_depth
        end

        def balanced?
            difference = depth(self.root.left_child) - depth(self.root.right_child)
            difference == -1 || difference == 0 || difference == 1 ? true : false
        end

        def rebalance!
            @root = self.build_tree(self.level_order.sort.map { |value| Node.new(value) })
        end


        private

        def find_parent(value, root=self.root)
            
            if !tree_includes?(value)
                not_in_tree_error_message
                return
            end

            if self.root.value == value
                root_value_error_message
                return
            end

            if root.left_child
                return root if root.left_child.value == value
            end

            if root.right_child
                return root if root.right_child.value == value
            end
            
            if value < root.value && root.left_child
                return find_parent(value, root.left_child)
            end

            if value > root.value && root.right_child
                return find_parent(value, root.right_child)
            end
            
        end

        def root_value_error_message
            puts "Error: This value is the root of the Tree."
        end

        def not_in_tree_error_message
            puts "Error: This value is not in the Tree."
        end

        def tree_includes?(value)
            find(value) ? true : false
        end

        def duplicate_error_message
            puts "Error: This value is already in the Tree."
        end

    end
end
#if you insert find doesn't work -- need to rebalance

#my_tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
#my_tree.build_tree
#my_tree.insert(10)
#my_tree.insert(12)
#puts my_tree.root
#my_tree.delete(67)
#p my_tree.postorder { |n| n + 1}
#my_tree.rebalance!
#p my_tree.root



    

=begin
    def assign_levels(root, array=[])
        return if !root.left_child && !root.right_child
        
        if root.left_child
            root.left_child.level = root.level + 1
            assign_levels(root.left_child)
        end
        
        if root.right_child
            root.right_child.level = root.level + 1
            assign_levels(root.right_child)
        end
    end

    def order_by_level(array, sorted=[])
        array.group_by { |node| node.level }.sort_by { |k, v| k }.each do |k, v|
            sorted << v
        end
    
        sorted.flatten
    end
=end



