-module(linkedList2).
-export([createNewBlock/1,push/2,main/0]).

-record(block,{prev,prev_id,id,timestamp}). %no need for nonce

createNewBlock(Id)->
	Timestamp =calendar:local_time(),
	#block{ id = Id, timestamp = Timestamp}.

push(LastBlock,CurrentBlock)-> 
	if LastBlock == nil ->
		CurrentBlock#block{prev = LastBlock};
		true->
		CurrentBlock#block{prev = LastBlock,prev_id = LastBlock#block.id}
	end.

main()->
	First = nil,
	Second_id = 1,
	Third_id = 2,
	Fourth_id =3,
	FirstB = createNewBlock(Second_id),
	Blockchain = push(First, FirstB),
	SecondB = createNewBlock(Third_id),
	Blockchain2 = push(Blockchain,SecondB),
	Thirdb= createNewBlock(Fourth_id),
	Blockchain3 = push(Blockchain2,Thirdb),
	io:fwrite("blockchain ~w", [Blockchain3]),
	ok.