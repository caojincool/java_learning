package simpleversion;



public class SimpleDotCom {
	int [] locationCells;
	int numOfHits=0;
	
	public void setLocationCells(int [] locs){
		locationCells=locs;
	}

	public String checkYourself(String stringGuess){
		int guess =Integer.parseInt(stringGuess);
		String result="miss";
		for (int cell:locationCells){
			if (guess == cell){
				result="hit";
				numOfHits++;
				break;
			}
		}
		if (numOfHits==locationCells.length){
			result = "kill";
			
		}
		System.out.println(result);
		return result;
	}
	/*public int[] setlocationcells(int[] locationcells){
		return null;
	}
	public static String checkYourself(String userguess){
		
		return null;
	}*/
}