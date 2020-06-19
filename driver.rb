require_relative 'binary_search_trees.rb'
include BinarySearchTree


#1. Create a binary search tree from an array of random numbers (`Array.new(15) { rand(1..100) }`)
    my_tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
#2. Confirm that the tree is balanced by calling `#balanced?`
    p my_tree.balanced?
#3. Print out all elements in level, pre, post, and in order
    puts my_tree.level_order
    puts my_tree.preorder
    puts my_tree.postorder
    puts my_tree.inorder
#4. try to unbalance the tree by adding several numbers > 100
    my_tree.insert(301)
    my_tree.insert(322)
    my_tree.insert(498)
    my_tree.insert(8456)
    my_tree.insert(32202)
#5. Confirm that the tree is unbalanced by calling `#balanced?`
    p my_tree.balanced?
#6. Balance the tree by calling `#rebalance!`
    my_tree.rebalance!
#7. Confirm that the tree is balanced by calling `#balanced?`
    p my_tree.balanced?
#8. Print out all elements in level, pre, post, and in order
    puts my_tree.level_order
    puts my_tree.preorder
    puts my_tree.postorder
    puts my_tree.inorder