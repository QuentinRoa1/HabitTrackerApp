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
				
				if ($DATA[0]['admin'] && $_GET['id'])
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
		if ($_GET['session'] && ($_GET['task'] || $_GET['tag'] || $_GET['start'] || $_GET['end']))
		{	
			$UID = checkSession($DBConnection, $_GET['session']);
			
			// Check if the session is allowed
			if ($UID == 0)
				return;
			
			$query = "select * from `habits` where";
			
			if ($_GET['task'])
				$query = $query."`task`='".$_GET['task']."' AND ";
				
			if ($_GET['tag'])
				$query = $query."`tag`='".$_GET['tag']."' AND ";
				
			if ($_GET['start'])
			{
				$startDate = date('Y-m-d', strtotime($_GET['start']));
				$query = $query."`start`='".$startDate."' AND ";
			}
				
			if ($_GET['end'])
			{
				$endDate = date('Y-m-d', strtotime($_GET['end']));
				$query = $query."`end`='".$endDate."' AND ";
			}
			
			$query = $query."uid=".$UID.";";
			
			// Run Query
			$result = $DBConnection->query($query);
			
			$output = json_encode($result->fetch_all(MYSQLI_ASSOC));
			
			http_response_code(200);
			echo $output;
		}
		else
		{
			http_response_code(400);
			echo "Failed";
		}
	}
	
	Close($DBConnection);

?>