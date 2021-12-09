-module(merkleTree).

-export([main/0,createTree/1]).

-record(node,{hash,left,right,transaction}).

%returns root of the tree
%NOTE THE TRANSACTION DATA MUST BE  IN STRING
createTree(TransactionData)->
	ListOfHash= createFirstHash(TransactionData,[]),
	Tree = recursiveRoot(ListOfHash),
	Tree.

createFirstHash(TransactionData,Acc)-> %we use acc to make recursive terminal
	if 
		TransactionData== []->
			Acc;
		true->
			[H|T] = TransactionData,%hash =crypto:hash(sha256,H)hash = H
			Leaf = #node{hash = crypto:hash(sha256,H), transaction=H},
			NewAcc = Acc++[Leaf],
			createFirstHash(T, NewAcc)
	end.



%takes list of nodes and sum the hash together by blocks of two recursively
%returns the list of nodes with the hashed sum
recursiveSum(ListOfHash, Acc)->
	% io:fwrite("ACC")
	if
		length(ListOfHash) >= 2->
			{[Elem1 , Elem2], Tail} = lists:split(2,ListOfHash),
			% take out hash to hash the concatenation
			Hash1 = Elem1#node.hash,
			Hash2 =Elem2#node.hash,
			NewAcc = Acc++[#node{hash = crypto:hash(sha256,<<Hash1/binary ,Hash2/binary>>),left = Elem1, right = Elem2}],
			recursiveSum(Tail,NewAcc);
		length(ListOfHash) == 1 ->
			[Elem1|_] = ListOfHash,
			% no need to rehash see diagram in report
			NewAcc = Acc++[#node{hash = Elem1#node.hash,left =Elem1}],
			NewAcc;
		length(ListOfHash) == 0 ->
			Acc
	end.

%recursively calls recursive sum till we have create the root node
%returns root node in list eg return = [root]
recursiveRoot(ListOfHash)->
	if
		length(ListOfHash) == 1->
			[H] = ListOfHash,
			H;
		length(ListOfHash) >1->
			NewListOfHash = recursiveSum(ListOfHash,[]),
			recursiveRoot(NewListOfHash)
	end.



 main()->
	ListTest = ["1","2","3","4","5","6","7","8","9","10"],
	Check =createTree(ListTest),
	io:fwrite("look = ~w/n",[Check]).



