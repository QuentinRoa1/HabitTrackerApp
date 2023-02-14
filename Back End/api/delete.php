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
				$query = "SELECT id, username, email, created FROM users WHERE id='".$DATA[0]['id']."'";
		
				// Run Query
				$result = $DBConnection->query($query);
				
				$output = json_encode($result->fetch_all(MYSQLI_ASSOC));
				
				return $DATA[0]['id'];
			}
		}
	}
	
	$DBConnection = Connect();
	
	if ($_GET['session'] && $_GET['id'])
	{	
		$UID = checkSession($DBConnection, $_GET['session']);
		
		// Check if the session is allowed
		if ($UID == 0)
			return;
		
		$startDate = date('Y-m-d', strtotime($_GET['start']));
		$endDate = date('Y-m-d', strtotime($_GET['end']));
		
		$query = "DELETE FROM `habits` WHERE id=".$_GET['id']." AND uid=".$UID.";";
		
		// Run Query
		$result = $DBConnection->query($query);
		
		echo "Deleted";
	}
	else
	{
		echo "Failed";
	}
	
	Close($DBConnection);

?>