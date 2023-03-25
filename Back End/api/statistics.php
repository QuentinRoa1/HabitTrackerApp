<?php

	error_reporting(E_ALL & ~E_NOTICE);
	require 'include/database.php';
	
	function checkSession($DBConnection, $Session)
	{
		$query = "SELECT * FROM sessions WHERE token='".$Session."'";
		
		// Run Query
		$result = $DBConnection->query($query);
		
		if (!$result) 
		{
			return 0;
		}
		else
		{
			$output = json_encode($result->fetch_all(MYSQLI_ASSOC));
			
			// Generate Expire Date
			$currentDate = date('Y-m-d', strtotime(date('Y-m-d')));
			$DATA = json_decode($output, true);
			$startDate = date('Y-m-d', strtotime($DATA[0]["expires"]));
			
			// Check if the Token is Expired
			if($startDate < $currentDate) 
			{
				return 0;
			}
			else
			{
				$UID = $DATA[0]['uid'];
				$query = "SELECT id, username, email, admin, created FROM users WHERE id='".$UID."'";
		
				// Run Query
				$result = $DBConnection->query($query);
				
				$output = json_encode($result->fetch_all(MYSQLI_ASSOC));
				$DATA = json_decode($output, true);
				
				if ($DATA[0]['admin'])
				{
					if ($_GET['id'])
						return $_GET['id'];
					else
						return $UID;			
				}
				else
				{
					return $UID;
				}
			}
		}
	}
	
	$DBConnection = Connect();
	
	if ($_SERVER['REQUEST_METHOD'] == 'GET') 
	{
		if ($_GET['session'] && $_GET['date'] && $_GET['length'])
		{	
			$UID = checkSession($DBConnection, $_GET['session']);
			
			$return = new stdClass();
			$return->HabitsCount; // The amount of all habits in the time range
			$return->TagPercent; // The percent of Habit's per Tag [DONE]
			$return->HabitsDays; // The amount of habits completed each day there was a habit
			$return->ShortestHabit; // The Shortest time it took to compelete a Habit
			$return->LongestHabit; // The Longest time it took to compelete a Habit			
			
			// Check if the session is allowed
			if ($UID == 0)
				return;
			
			$date = date('Y-m-d', strtotime($_GET['date']));
			$dateEnd = date('Y-m-d', strtotime($_GET['date']." + ".$_GET['length']." day"));
			
			//$return->SearchedDate = $date;
			//$return->ToDate = $dateEnd;
			
			$query = "select * from habits where uid=".$UID." AND date(habits.end) between '".$date ."'  and   '".$dateEnd."';";
			
			// Run Query
			$result = $DBConnection->query($query);
			
			$tags = [];
			$task_amount = 0;
			if ($result->num_rows > 0) 
			{
				// output data of each row
				while($row = $result->fetch_assoc()) 
				{
					array_push($tags, $row["tag"]);
					$task_amount++;
				}
			}

			// Count the occurrences of each string
			$tags_counts = array_count_values($tags);

			// Calculate the percentage of each string occurrence
			$tags_percentages = array();
			$total_tags = count($tags);
			foreach ($tags_counts as $tags => $count) {
			  $percentage = ($count / $total_tags) * 100;
			  $tags_percentages[$tags] = $percentage;
			}
			
			$query = "SELECT
						DATEDIFF(max_habit.end, max_habit.start) AS max_duration_days,
						DATEDIFF(min_habit.end, min_habit.start) AS min_duration_days
					FROM habits AS max_habit
					JOIN habits AS min_habit
					ON max_habit.uid = min_habit.uid
					  AND max_habit.start >= '".$date ."' 
					  AND max_habit.end <= '".$dateEnd."'
					  AND min_habit.start >= '".$date ."' 
					  AND min_habit.end <= '".$dateEnd."'
					WHERE max_habit.uid = ".$UID."
					ORDER BY max_duration_days DESC, min_duration_days ASC
					LIMIT 1;";
			
			// Run Query
			$result = $DBConnection->query($query);
			$resultJson = json_encode($result->fetch_all(MYSQLI_ASSOC));
			$DATA = json_decode($resultJson, true);
			
			$query = "SELECT end, COUNT(*) AS count
					  FROM habits
					  WHERE uid = ".$UID." AND date(habits.end) BETWEEN '".$date ."' AND '".$dateEnd."'
					  GROUP BY end";
					  
			$result = $DBConnection->query($query);

			$return->HabitsCount = $task_amount;
			$return->TagPercent = $tags_percentages;	
			$return->HabitsDays = $result->fetch_all(MYSQLI_ASSOC);
			$return->ShortestHabit = $DATA[0]["min_duration_days"];
			$return->LongestHabit = $DATA[0]["max_duration_days"];				

			echo json_encode($return);
			//echo json_encode($result->fetch_all(MYSQLI_ASSOC));
		}
		else
		{
			http_response_code(400);
			echo "Failed";
		}
	}
	
	Close($DBConnection);

?>