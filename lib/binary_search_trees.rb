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
            @root = build_tree
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
            return duplicate_error_message if tree_includes?(value)

            smallest_node = self.level_order.sort_by { |n| n.value }[0]
            biggest_node = self.level_order.sort_by { |n| n.value }[-1]

            smallest_node.left_child = Node.new(value) if value < smallest_node.value
            biggest_node.right_child = Node.new(value) if value > biggest_node.value
        
            if value > smallest_node.value && value < biggest_node.value
                current_value = value
                current_value += 1 until tree_includes?(current_value)

                parent = self.find(current_value)
                new_node = Node.new(value)
                new_node.left_child = parent.left_child
                parent.left_child = new_node
            end
        end

        def delete(value)
            return not_in_tree_error_message if !tree_includes?(value)
            return root_value_error_message if value == self.root.value

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
            
            return find(value, root.left_child) if value < root.value && root.left_child
            return find(value, root.right_child) if value > root.value && root.right_child
        end

        def level_order(queue=[self.root], ordered=[], &block)
            while !queue.empty?
                queue << queue[0].left_child if queue[0].left_child
                queue << queue[0].right_child if queue[0].right_child
                ordered << queue.shift
            end

            block_given? ? ordered.uniq.map { |n| yield(n) } : ordered.uniq
        end

        def preorder(&block)
            def get_nodes(root=self.root, ordered=[])
                ordered << root
                get_nodes(root.left_child, ordered) if root.left_child
                get_nodes(root.right_child, ordered) if root.right_child

                ordered
            end

            block_given? ? get_nodes.map { |n| yield(n) } : get_nodes
        end

        def inorder(&block)
            def get_nodes(root=self.root, ordered=[])
                get_nodes(root.left_child, ordered) if root.left_child
                ordered << root
                get_nodes(root.right_child, ordered) if root.right_child

                ordered
            end

            block_given? ? get_nodes.map { |n| yield(n) } : get_nodes
        end

        def postorder(&block)
            def get_nodes(root=self.root, ordered=[])
                
                get_nodes(root.left_child, ordered) if root.left_child
                get_nodes(root.right_child, ordered) if root.right_child
                ordered << root

                ordered
            end

            block_given? ? get_nodes.map { |n| yield(n) } : get_nodes
        end

        def depth(root=self.root, depths=[])
            return 0 if root.leaf?
            
            leaves = level_order([root]).filter { |node| node.leaf? }
            current_node = leaves[0]

            leaves.each_with_index do |node, i|
                depths << 0
                until current_node == self.root
                    current_node = find_parent(current_node.value)
                    depths[i] += 1
                end

                current_node = leaves[i + 1] if leaves[i + 1]
            end

            depths.max
        end

        def balanced?
            difference = depth(self.root.left_child) - depth(self.root.right_child)
            difference == -1 || difference == 0 || difference == 1 ? true : false
        end

        def rebalance!
            @array = level_order.sort_by { |node| node.value }
            @array.each do |node|
                node.left_child = nil
                node.right_child = nil
            end

            @root = build_tree
        end


        private

        def find_parent(value, root=self.root)
            return nil if !tree_includes?(value) || self.root.value == value

            return root if root.left_child && root.left_child.value == value 
            return root if root.right_child && root.right_child.value == value
            
            return find_parent(value, root.left_child) if root.left_child && value < root.value
            return find_parent(value, root.right_child) if root.right_child && value > root.value 
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