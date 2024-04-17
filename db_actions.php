<?php
// receive a POST call
if ($_SERVER["REQUEST_METHOD"] == "POST") {
	// check if the request has the expected parameters
	if (isset($_POST["func"])) {
		// retrieve the values from the POST parameters
		$func = $_POST["func"];

		switch ($func) {
			case "addUser":
				if (isset($_POST["password"]) && isset($_POST["name"])) {
					$password = $_POST["password"];
					$name = $_POST["name"];
					$userid = addUser($conn, $password, $name);
					echo "User added with ID: " . $userid;
					return $userid;
				} else {
					echo "Missing parameters in the POST request.";
				}
				break;
			case "viewUsers":
				viewUsers($conn);
				break;
			case "viewAdmins":
				viewAdmins($conn);
				break;
			case "verifyLogin":
				if (isset($_POST["uid"]) && isset($_POST["pass"])) {
					$uid = $_POST["uid"];
					$pass = $_POST["pass"];
					$array = verifyLogin($conn, $uid, $pass);
					if($array==null) {
						echo("Invalid login credentials.");
					}
					else {
						echo("Login successful.");
					}
					return $array;
				} else {
					echo "Missing parameters in the POST request.";
				}
				break;
			case "isAdmin":
				if (isset($_POST["uid"])) {
					$uid = $_POST["uid"];
					isAdmin($conn, $uid);
				} else {
					echo "Missing parameters in the POST request.";
				}
				break;
			case "getEvent":
				if (isset($_POST["Events_ID"])) {
					$Events_ID = $_POST["Events_ID"];
					$array = getEvent($conn, $Events_ID);
					$count = count($array);
					for($x=0;$x<$count;$x++){ //first index is the row of table, second index is column
					  printf("Events_ID: %d,", $array[$x]["Events_ID"]);
					  printf("Name: %s,", $array[$x]["Name"]);
					  printf("Description: %s,", $array[$x]["Description"]);
					  printf("Location: %s,", $array[$x]["Location"]);
					  printf("Date: %s,", $array[$x]["Date"]);
					  printf("Time: %s,", $array[$x]["Time"]);
					  printf("Category: %s\n", $array[$x]["Category"]);
					}
				} else {
					echo "Missing parameters in the POST request.";
				}
				break;
			case "getRSOEvents":
				if (isset($_POST["RSO_ID"])) {
					$RSO_ID = $_POST["RSO_ID"];
					$array = getRSOEvents($conn, $RSO_ID);
					$count = count($array);
					for($x=0;$x<$count;$x++){ //first index is the row of table, second index is column
					  printf("Events_ID: %d,", $array[$x]["Events_ID"]);
					  printf("Name: %s,", $array[$x]["Name"]);
					  printf("Description: %s,", $array[$x]["Description"]);
					  printf("Location: %s,", $array[$x]["Location"]);
					  printf("Date: %s,", $array[$x]["Date"]);
					  printf("Time: %s,", $array[$x]["Time"]);
					  printf("Category: %s\n", $array[$x]["Category"]);
					}
				} else {
					echo "Missing parameters in the POST request.";
				}
				break;
		}
		// return a response if needed
		// ...
	} else {
		// handle the case when the expected parameters are missing
		echo "Missing parameters in the POST request.";
	}
}
//Adds a user into the database and returns the user ID associated with that user. User IDs
// are an auto-incrementing number, so MAX works fine to find the value of any new user, even if
// old users are deleted.
function addUser($conn, $password, $name) {
	$stmt = $conn->prepare("INSERT INTO users (pass, name) VALUES (?,?)");
	$stmt->bind_param("ss", $password, $name);
	$stmt->execute();
	$stmt = $conn->prepare("SELECT MAX(UID) FROM users U");
	$stmt->execute();
	$result = $stmt->get_result();
	$userid = mysqli_fetch_row($result);
	//printf("User ID of newly created user = %d", $userid[0]);
	return($userid[0]);
}

function viewUsers($conn) {
	$sql = "SELECT UID,pass FROM users";
	$result = mysqli_query($conn,$sql);
	$row=mysqli_fetch_all($result,MYSQLI_ASSOC);
	$count = count($row);
	for($x=0;$x<$count;$x++){ //first index is the row of table, second index is column
	  printf("UID: %d,", $row[$x]["UID"]);
	  printf("pass: %s\n", $row[$x]["pass"]);
	  }
}

function viewAdmins($conn) {
	$sql = "SELECT U.UID, A.Admins_ID FROM users U,admin A WHERE U.UID=A.UID";
	$result = mysqli_query($conn,$sql);
	$row = mysqli_fetch_all($result,MYSQLI_ASSOC);
	$count = count($row);
	for($x = 0; $x < $count; $x++){ //first index is the row of table, second index is column
	  printf("UID: %d,", $row[$x]["UID"]);
	  printf("Admins_ID: %d\n", $row[$x]["Admins_ID"]);
	  }
}

//Function that takes a user ID and a password and checks if there's a user that matches those credentials
function verifyLogin($conn, $uid, $pass) {
	$sql = "SELECT * FROM users WHERE UID = ? AND pass = ?";
	$stmt = $conn->prepare($sql);
	$stmt->bind_param("ss", $uid, $pass);
	$stmt->execute();
	$result = $stmt->get_result();
	//Fetch all ***shouldnt*** be problematic here, since user IDs are unique only 1 entry should be in the array
	$array = mysqli_fetch_all($result, MYSQLI_ASSOC);
	//printf("result is: %s", $array[0]["name"]);
	return $array;
}

//Function that determines if a user is an admin or not from a user ID
function isAdmin($conn, $uid) {
	$sql = "SELECT * FROM users U, admin A WHERE U.UID = ? AND U.UID = A.UID";
	$stmt = $conn->prepare($sql);
	$stmt->bind_param("s", $uid);
	$stmt->execute();
	$result = $stmt->get_result();
	$array = mysqli_fetch_all($result, MYSQLI_NUM);
	if($array==null) {
		echo("false");
		return false;
	}
	echo("true");
	return true;
}

//Returns an array containing the data of an event given an event ID
function getEvent($conn, $Events_ID) {
	$sql = "SELECT * FROM events WHERE Events_ID=?";
	$stmt = $conn->prepare($sql);
	$stmt->bind_param("s", $Events_ID);
	$stmt->execute();
	$result = $stmt->get_result();
	$array = mysqli_fetch_all($result, MYSQLI_ASSOC);
	return $array;
}

//Get a list of events hosted by an RSO from a given RSO ID
function getRSOEvents($conn, $RSO_ID) {
	$sql = "SELECT * FROM events E, rso_events R WHERE E.Events_ID=R.Events_ID AND R.RSO_ID=?";
	$stmt = $conn->prepare($sql);
	$stmt->bind_param("s", $RSO_ID);
	$stmt->execute();
	$result = $stmt->get_result();
	$array = mysqli_fetch_all($result, MYSQLI_ASSOC);
	return $array;
}

//Return a list of all events a user can see
function viewEvents($conn, $uid) {
	//If user is an admin, they can see all events
	if (isAdmin($conn, $uid) == true) {
		$sql = "SELECT * FROM events";
		$result = mysqli_query($conn, $sql);
		$array = mysqli_fetch_all($result, MYSQLI_NUM);
		return $array;
	}
	//Else user can see public events, private events from university, and RSO events for which
	//RSO they are a part of 
	else {
		//Fetch RSO events they can see
		$sql = "SELECT * FROM events E, rso_events R, users U WHERE E.Events_ID = R.Events_ID AND 
				R.RSO_ID = U.RSO_ID";
		$result = mysqli_query($conn, $sql);
		$array = mysqli_fetch_all($result, MYSQLI_NUM);
		//Fetch public events (everyone can see)
		$sql = "SELECT * FROM events E, public_events P WHERE E.Events_ID=P.Events_ID";
		$result = mysqli_query($conn, $sql);
		$array2 = mysqli_fetch_all($result, MYSQLI_NUM);
		$result_arr = array_merge($array, $array2);
		//Fetch private events for university (still everyone can see bc there is no implementation for
		//events of other universities yet)
		$sql = "SELECT * FROM events E, private_events P WHERE E.Events_ID=P.Events_ID";
		$result = mysqli_query($conn, $sql);
		$array2 = mysqli_fetch_all($result, MYSQLI_NUM);
		$result_arr = array_merge($array, $array2);
		return $result_arr;
	}
}
?>
