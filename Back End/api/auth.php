<?php

	error_reporting(E_ALL & ~E_NOTICE);
	require 'include/database.php';
	
	function generateKey($n) 
	{
		$characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
		$randomString = '';
	 
		for ($i = 0; $i < $n; $i++) {
			$index = rand(0, strlen($characters) - 1);
			$randomString .= $characters[$index];
		}
	 
		return $randomString;
	}
	
	$DBConnection = Connect();
	
	if ($_SERVER['REQUEST_METHOD'] == 'GET') 
	{
		if ($_GET['username'] && $_GET['password'] && !$_GET['email'])
		{	
			$query = "SELECT id, username, email, admin, created FROM users WHERE username='".$_GET['username']."' AND password='".hash('sha256', $_GET['password'])."'";
			
			// Run Query
			$result = $DBConnection->query($query);
			
			if (!$result) 
			{
				throw new Exception("No Results Found"); 
				//echo "No Results";
			}
			else
			{
				$output = json_encode($result->fetch_all(MYSQLI_ASSOC));
				
				// Generate Expire Date
				$EXPDATE = strtotime("+30 day");
				$EXPDATE = date('Y-m-d', $EXPDATE);
				$KEY = generateKey(64);
				$DATA = json_decode($output, true);
				
				if ($DATA[0]["id"])
				{			
				$query = "INSERT INTO `sessions`(`uid`, `token`, `device`, `expires`) VALUES (".$DATA[0]["id"].",'".$KEY."','".$IP = $_SERVER['REMOTE_ADDR']."','".$EXPDATE."')";
				
				// Run Query
				$result = $DBConnection->query($query);
				
				$DATA[0]["session"] = $KEY;
				echo json_encode($DATA);
				}
				else
				{
					http_response_code(204);
					echo "Not Found";
				}
			}
		}
		else
		{
			http_response_code(400);
			echo "Failed";
		}
	}
	else if ($_SERVER['REQUEST_METHOD'] == 'POST') 
	{
		if ($_GET['username'] && $_GET['password'] && $_GET['email'])
		{
			$query = "SELECT id, username, email, created FROM users WHERE username='".$_GET['username']."' OR email='".$_GET['email']."'";
			
			// Run Query
			$result = $DBConnection->query($query);
			
			if (!$result) 
			{
				echo "No Results";
			}
			else
			{
				$output = json_encode($result->fetch_all(MYSQLI_ASSOC));
				$DATA = json_decode($output, true);
				
				if ($DATA[0]["id"])
				{			
					http_response_code(400);
					echo "Already in use";
				}
				else
				{					
					$query = "INSERT INTO `users`(`username`, `email`, `password`) VALUES ('".$_GET['username']."','".$_GET['email']."','".hash('sha256', $_GET['password'])."')";
					
					// Run Query
					$result = $DBConnection->query($query);
					
					http_response_code(200);
					echo "Created";
				}
			}
		}
		else
		{
			http_response_code(400);
			echo "Failed";
		}
	}
	else if ($_SERVER['REQUEST_METHOD'] == 'PUT') 
	{
		if ($_GET['session'])
		{
			$query = "SELECT * FROM sessions WHERE token='".$_GET['session']."'";
			
			// Run Query
			$result = $DBConnection->query($query);
			
			if (!$result) 
			{
				echo "No Results";
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
					echo "Expired";
				}
				else
				{
					$query = "SELECT id, username, email, admin, created FROM users WHERE id='".$DATA[0]['id']."'";
			
					// Run Query
					$result = $DBConnection->query($query);
					
					$output = json_encode($result->fetch_all(MYSQLI_ASSOC));
					
					echo $output;
				}
			}
		}
		else
		{
			http_response_code(400);
			echo "Failed";
		}
	}
	
	Close($DBConnection);

?>
