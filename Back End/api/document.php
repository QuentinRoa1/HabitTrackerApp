<?php

	error_reporting(E_ALL & ~E_NOTICE);
	require 'include/database.php';
	
	$DBConnection = Connect();
	
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
	
	if ($_SERVER['REQUEST_METHOD'] == 'GET') 
	{
		if ($_GET['session'])
		{	
			$UID = checkSession($DBConnection, $_GET['session']);
			
			// Check if the session is allowed
			if ($UID == 0)
				die("No User");
		}
		else
		{
			die("No Session");
		}
	}

?>

<html>
	<head>
		<title>Documentation</title>
	</head>
	<body>
		<div>
			<iframe src="doc.pdf" width="100%" height="100%">
		</div>
	</body>
</html>