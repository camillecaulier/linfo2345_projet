-module(linkedList2).
-export([createNewBlock/1,push/2,main/0]).

-record(block,{prev,prev_id,id,timestamp}). %no need for nonce

createNewBlock(Id)->
	Timestamp =timer:time(),
	#block{ id = Id, timestamp = Timestamp}.

push(LastBlock,CurrentBlock)-> 
	if LastBlock == nil ->
		CurrentBlock#block{prev = LastBlock};
		true->
		CurrentBlock#block{prev = LastBlock,prev_id = LastBlock#block.id}
	end.

main()->
	ok.