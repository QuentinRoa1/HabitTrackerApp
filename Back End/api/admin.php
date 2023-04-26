<!DOCTYPE html>
<html>
<head>
	<title>Admin Portal</title>
	<!-- Bootstrap CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<!-- jQuery library -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<!-- Bootstrap JS -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<body>
	<div class="container mt-3">
		<?php
		
			error_reporting(E_ALL & ~E_NOTICE);
			require 'include/database.php';		
					
			// Connect to the database
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
							return 1;			
						}
						else
						{
							return 0;
						}
					}
				}
			}
		
			// Check if Admin
			$UID = 0;
			if ($_GET['session'])
			{
				$UID = checkSession($DBConnection, $_GET['session']);
			}
			
			if ($UID != 1)
				die("You do not have permisson to view this page");

			// Display a table of all the data in the database
			$sql = "SELECT * FROM users";
			$result = $DBConnection->query($sql);
			if ($result->num_rows > 0) {
				echo "<table class='table'>";
				echo "<thead class='thead-dark'><tr><th>ID</th><th>Username</th><th>Email</th><th>Admin</th><th>Created</th></tr></thead>";
				while($row = $result->fetch_assoc()) {
					echo "<tr><td>" . $row["id"]. "</td><td>" . $row["username"]. "</td><td>" . $row["email"]. "</td><td>" . $row["admin"]. "</td><td>" . $row["created"]. "</td></tr>";
				}
				echo "</table>";
			} else {
				echo "No data found";
			}

			// Add a new record to the database
			if ($_SERVER["REQUEST_METHOD"] == "POST") 
			{
				$toUpdate = "";
				
				if ($_POST["name"])
					$toUpdate = $toUpdate."username='".$_POST["name"]."', ";
				if ($_POST["email"])
					$toUpdate = $toUpdate."email='".$_POST["email"]."', ";
				if ($_POST["admin"])
					$toUpdate = $toUpdate."admin=".$_POST["admin"].", ";
				
				$toUpdate = substr($toUpdate, 0, -2);
				
				$sql = "UPDATE users SET ".$toUpdate." WHERE id=".$_POST["id"];
				if ($DBConnection->query($sql) === TRUE) 
				{
					echo "<div class='alert alert-success' role='alert'>";
					echo "Record Updated successfully";
					echo "</div>";
				} 
				else 
				{
					echo "<div class='alert alert-danger' role='alert'>";
					echo "Error adding record: " . $DBConnection->error;
					echo "</div>";
				}
			}
			
			// Close the database connection
			$DBConnection->close();
		?>
	</div>
	
	<div class="container mt-3">
		<form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>?session=<?php echo $_GET['session'];?>" class="form-inline">
			<div class="form-group mr-2">
				<label for="id" class="mr-2">ID:</label>
				<input type="text" name="id" size="2" class="form-control" required>
			</div>
			<div class="form-group mr-2">
				<label for="name" class="mr-2">Username:</label>
				<input type="text" name="name" size="10" class="form-control">
			</div>
			<div class="form-group mr-2">
				<label for="email" class="mr-2">Email:</label>
				<input type="text" name="email" size="10" class="form-control">
			</div>
			<div class="form-group mr-2">
				<label for="admin" class="mr-2">Admin:</label>
				<input type="text" name="admin" size="1" class="form-control">
			</div>
			<input type="submit" value="Update" class="btn btn-primary">
		</form>
	</div>
		
	
</body>
</html>
