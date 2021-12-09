-module(linkedList2).
-export([createNewBlock/2,push/2,main/0]).

-record(block,{prev,prev_id,id,timestamp}g). %no need for nonce

createNewBlock(Prev_id, Id)->
	Timestamp =timer:time(),
	#block{prev_id = Prev_id, id = Id, timestamp = Timestamp}.

push(LastBlock,CurrentBlock)-> 
	CurrentBlock#block{prev = LastBlock}.

main()->
	ok.