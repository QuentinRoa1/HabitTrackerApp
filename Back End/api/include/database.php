<?php

	function Connect()
	{
		// SQL Connection Info
		$servername = "REDACTED";
		$db_name = "REDACTED";
		$username = "REDACTED";
		$password = "REDACTED";
		
		// Create SQL connection
		$con = new mysqli($servername, $username, $password, $db_name);
		
		if ($con->connect_error) 
		{
			die("Connection failed: " . $conn->connect_error);
		}
		else
		{
			return $con;
		}
	}
	
	function Close($con)
	{
		// Close SQL Connection
		$con->close();
	}
?>