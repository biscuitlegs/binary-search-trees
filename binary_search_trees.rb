require 'pry'

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
        
        if value < root.value && value > root.left_child.value
            new_node = Node.new(value)
            new_node.left_child = root.left_child
            root.left_child = new_node
            return
        end
        
        if value > root.value && value < root.right_child.value
            new_node = Node.new(value)
            new_node.right_child = root.right_child
            root.right_child = new_node
            return
        end

        
        value > root.value ? insert(value, root.right_child) : insert(value, root.left_child)
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


    private

    def tree_includes?(value)
        find(value) ? true : false
    end

    def duplicate_error_message
        puts "Error: This value is already in the Tree."
    end

end

my_tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
my_tree.build_tree
my_tree.insert(6)
puts my_tree.root
p my_tree.find(6)





    

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



