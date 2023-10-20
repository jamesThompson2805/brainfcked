class BrainFuck
{
	var tape:Array<Float>;
	var bitSize:Int = 3;
	var ptr:Int;

	var maxIterations:Int = 1000;

	public function new(newTape:Array<Float>)
	{
		this.tape = newTape.copy();
		ptr = 0;
	}

	function findNextClose(expr:String, cPtr:Int):Int
	{
		var incPtr:Int = cPtr;
		while (incPtr < expr.length)
		{
			if (expr.charAt(incPtr) == "]")
				return incPtr;
			incPtr++;
		}
		return -1;
	}

	function findLastOpen(expr:String, cPtr:Int):Int
	{
		var decPtr:Int = cPtr;
		while (decPtr >= 0)
		{
			if (expr.charAt(decPtr) == "[")
				return decPtr;
			decPtr--;
		}
		return -1;
	}

	function inc(index:Int)
	{
		if (tape[index] >= (2 << bitSize) - 1)
		{
			tape[index] = -1 * (2 << bitSize);
		}
		else
			tape[index]++;
	}

	function dec(index:Int)
	{
		if (tape[index] <= -1 * (2 << bitSize))
		{
			tape[index] = (2 << bitSize) + 1;
		}
		else
			tape[index]--;
	}

	public function evalExpr(expr:String):Bool
	{
		ptr = 0;

		var count:Int = 0;
		var insPtr:Int = 0;

		var symbol:String;
		var tapeBackup:Array<Float> = tape.copy();

		while (insPtr < expr.length)
		{
			if (count > maxIterations)
			{
				tape = tapeBackup.copy();
				return false;
			}
			symbol = expr.charAt(insPtr);
			switch (symbol)
			{
				case "+":
					inc(ptr);
				case "-":
					dec(ptr);
				case ">":
					ptr == tape.length - 1 ? ptr = 0 : ptr++;
				case "<":
					ptr == 0 ? ptr = tape.length - 1 : ptr--;
				case "[":
					{
						if (tape[ptr] == 0)
						{
							var goTo:Int = findNextClose(expr, insPtr);
							if (goTo == -1)
							{
								tape = tapeBackup.copy();
								return false;
							}
							insPtr = goTo;
						}
					}
				case "]":
					{
						if (tape[ptr] != 0)
						{
							var goTo:Int = findLastOpen(expr, insPtr);
							if (goTo == -1)
							{
								tape = tapeBackup.copy();
								return false;
							}
							insPtr = goTo;
						}
					}
			}
			insPtr++;
			count++;
		}
		return true;
	}

	public function getTape()
	{
		return tape.copy();
	}

	public function setTape(newTape:Array<Float>)
	{
		this.tape = newTape.copy();
	}
}
