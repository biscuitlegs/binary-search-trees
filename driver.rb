require_relative 'binary_search_trees.rb'
include BinarySearchTree


#1. Create a binary search tree from an array of random numbers (`Array.new(15) { rand(1..100) }`)
    my_tree = Tree.new([63, 39, 22, 14, 38, 48, 40, 50, 82, 88, 86, 67, 73, 65])
#2. Confirm that the tree is balanced by calling `#balanced?`
    #puts my_tree.balanced?
#3. Print out all elements in level, pre, post, and in order
    #puts my_tree.level_order
    #puts my_tree.preorder
    #puts my_tree.postorder
    #puts my_tree.inorder
#4. try to unbalance the tree by adding several numbers > 100
    my_tree.insert(13)
    my_tree.insert(12)
    my_tree.insert(11)
#5. Confirm that the tree is unbalanced by calling `#balanced?`
    p my_tree.balanced?
#6. Balance the tree by calling `#rebalance!`
#7. Confirm that the tree is balanced by calling `#balanced?`
#8. Print out all elements in level, pre, post, and in order