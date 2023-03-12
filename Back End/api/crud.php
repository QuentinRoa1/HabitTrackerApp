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
	
	if ($_SERVER['REQUEST_METHOD'] == 'POST') {
		if ($_GET['session'] && $_GET['task'] && $_GET['tag'] && $_GET['start'] && $_GET['end'])
		{	
			$UID = checkSession($DBConnection, $_GET['session']);
			
			// Check if the session is allowed
			if ($UID == 0)
				return;
			
			$startDate = date('Y-m-d', strtotime($_GET['start']));
			$endDate = date('Y-m-d', strtotime($_GET['end']));
			
			$query = "INSERT INTO `habits`(`uid`, `task`, `tag`, `start`, `end`) VALUES (".$UID.",'".$_GET['task']."','".$_GET['tag']."','".$startDate."','".$endDate."')";
			
			// Run Query
			$result = $DBConnection->query($query);
			
			http_response_code(200);
			echo "Created";
		}
		else
		{
			http_response_code(400);
			echo "Failed";
		}
	}
	elseif ($_SERVER['REQUEST_METHOD'] == 'GET') 
	{
		if ($_GET['session'])
		{	
			$UID = checkSession($DBConnection, $_GET['session']);
			
			// Check if the session is allowed
			if ($UID == 0)
				return;
			
			$startDate = date('Y-m-d', strtotime($_GET['start']));
			$endDate = date('Y-m-d', strtotime($_GET['end']));
			
			$query = "SELECT * FROM `habits` WHERE uid=".$UID.";";
			
			// Run Query
			$result = $DBConnection->query($query);
			
			$output = json_encode($result->fetch_all(MYSQLI_ASSOC));
			
			echo $output;
		}
		else
		{
			http_response_code(400);
			echo "Failed";
		}
	}
	elseif ($_SERVER['REQUEST_METHOD'] == 'PUT') 
	{
		if ($_GET['session'] && $_GET['id'] && ($_GET['task'] || $_GET['tag'] || $_GET['start'] || $_GET['end']))
		{	
			$UID = checkSession($DBConnection, $_GET['session']);
			
			// Check if the session is allowed
			if ($UID == 0)
				return;
			
			$query = "UPDATE `habits` SET ";
			
			if ($_GET['task'])
				$query = $query."`task`='".$_GET['task']."',";
				
			if ($_GET['tag'])
				$query = $query."`tag`='".$_GET['tag']."',";
				
			if ($_GET['start'])
			{
				$startDate = date('Y-m-d', strtotime($_GET['start']));
				$query = $query."`start`='".$startDate."',";
			}
				
			if ($_GET['end'])
			{
				$endDate = date('Y-m-d', strtotime($_GET['end']));
				$query = $query."`end`='".$endDate."',";
			}
			
			$query = substr($query, 0, -1)."WHERE id=".$_GET['id']." AND uid=".$UID.";";
			
			// Run Query
			$result = $DBConnection->query($query);
			
			http_response_code(200);
			echo "Updated";
		}
		else
		{
			http_response_code(400);
			echo "Failed";
		}
	}
	elseif ($_SERVER['REQUEST_METHOD'] == 'DELETE') 
	{
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
			
			http_response_code(200);
			echo "Deleted";
		}
		else
		{
			http_response_code(400);
			echo "Failed";
		}
	}
	
	Close($DBConnection);

?>