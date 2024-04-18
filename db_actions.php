<?php
include 'db_connection.php';
$conn = OpenCon();

$action = $_GET['action'];

switch ($action) {
	case "addUser":
		echo addUser($conn);
		break;
	case "addEvent":
		echo addEvent($conn);
		break;
	case "viewUsers":
		echo viewUsers($conn);
		break;
	case "viewAdmins":
		echo viewAdmins($conn);
		break;
	case "verifyLogin":
		echo verifyLogin($conn);
		break;
	case "isAdmin":
		echo isAdmin($conn);
		break;
	case "getEvent":
		echo getEvent($conn);
		break;
	case "getRSOEvents":
		echo getRSOEvents($conn);
		break;
	case "viewEvents":
		echo viewEvents($conn);
		break;
	default:
		http_response_code(404);
		echo("Invalid action");
		break;
}

mysqli_close($conn);

//Adds a user into the database and returns the user ID associated with that user. User IDs
// are an auto-incrementing number, so MAX works fine to find the value of any new user, even if
// old users are deleted.
function addUser($conn) {
	//unpack received json data
	$json = file_get_contents('php://input');
	$json_obj = json_decode($json, true);
	$password = $json_obj['password'];
	$email = $json_obj['email'];

	$stmt = $conn->prepare("INSERT INTO users (pass, name) VALUES (?,?)");
	$stmt->bind_param("ss", $password, $email);
	$stmt->execute();
	$stmt = $conn->prepare("SELECT MAX(UID) FROM users U");
	$stmt->execute();
	$result = $stmt->get_result();
	$userid = mysqli_fetch_row($result);
	//printf("User ID of newly created user = %d", $userid[0]);

	//Return the user ID of the newly created user in JSON format
	$arr = array('id' => $userid[0], 'email' => $email);
	return (json_encode($arr));
}

function addEvent($conn){
	//unpack received json data
	$json = file_get_contents('php://input');
	$json_obj = json_decode($json, true);
	$time = $json_obj['time'];
	$lname = $json_obj['lname'];
	$eventName = $json_obj['eventName'];
	$description = $json_obj['description'];

	$stmt = $conn->prepare("INSERT INTO events (time, Lname, Event_Name, Description) 
		VALUES (?,?,?,?)");
	$stmt->bind_param("ssss", $, $time, $lname, $eventName, $description);
	$stmt->execute();
	$result = $stmt->get_result();
	if ($result == false) {
		http_response_code(400);
		return "";
	}
	return (json_encode($result));
}

function viewUsers($conn) {
	$sql = "SELECT UID,name FROM users";
	$result = mysqli_query($conn,$sql);
	$array = mysqli_fetch_all($result,MYSQLI_ASSOC);
	return(json_encode($array));
}

function viewAdmins($conn) {
	$sql = "SELECT U.UID, A.Admins_ID FROM users U,admin A WHERE U.UID=A.UID";
	$result = mysqli_query($conn,$sql);
	$array = mysqli_fetch_all($result,MYSQLI_ASSOC);
	return(json_encode($array));
}

//Function that takes a user ID and a password and checks if there's a user that matches those credentials
function verifyLogin($conn) {
	//unpack received json data
	$json = file_get_contents('php://input');
	$json_obj = json_decode($json, true);
	$password = $json_obj['password'];
	$email = $json_obj['email'];


	$sql = "SELECT * FROM users WHERE name = ? AND pass = ?";
	$stmt = $conn->prepare($sql);
	$stmt->bind_param("ss", $email, $password);
	$stmt->execute();
	$result = $stmt->get_result();
	//Fetch all ***shouldnt*** be problematic here, since user IDs are unique only 1 entry should be in the array
	$array = mysqli_fetch_all($result, MYSQLI_ASSOC);
	//printf("result is: %s", $array[0]["name"]);
	//If the array is empty, then the user does not exist
	if($array == null) {
		$arr = array('id' => 0);
		return (json_encode($arr));
	} else {
		$arr = array('id' => $array[0]["UID"]);
		return (json_encode($arr));
	}
}

//Function that determines if a user is an admin or not from a user ID
function isAdmin($conn) {
	$UID = $_GET['UID'];

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
function getEvent($conn) {
	$Events_ID = $_GET['Events_ID'];


	$sql = "SELECT * FROM events WHERE Events_ID=?";
	$stmt = $conn->prepare($sql);
	$stmt->bind_param("s", $Events_ID);
	$stmt->execute();
	$result = $stmt->get_result();
	$array = mysqli_fetch_all($result, MYSQLI_ASSOC);

	//If the array is empty, then the event for that id does not exist
	if($array == null) {
		http_response_code(400);
		return "";
	} else {
		return (json_encode($array));
	}
}

//Get a list of events hosted by an RSO from a given RSO ID
function getRSOEvents($conn) {
	$RSO_ID = $_GET['RSO_ID'];
	
	$sql = "SELECT * FROM events E, rso_events R WHERE E.Events_ID=R.Events_ID AND R.RSO_ID=?";
	$stmt = $conn->prepare($sql);
	$stmt->bind_param("s", $RSO_ID);
	$stmt->execute();
	$result = $stmt->get_result();
	$array = mysqli_fetch_all($result, MYSQLI_ASSOC);
	if($array == null) {
		http_response_code(400);
		return "";
	} else {
		return (json_encode($array));
	}
}

//Return a list of all events a user can see
function viewEvents($conn) {
	$UID = $_GET['UID'];
	//If user is an admin, they can see all events
	if (isAdmin($conn, $uid) == true) {
		$sql = "SELECT * FROM events";
		$result = mysqli_query($conn, $sql);
		$array = mysqli_fetch_all($result, MYSQLI_NUM);
		return (json_encode($array));
	}
	//Else user can see public events, private events from university, and RSO events for which
	//RSO they are a part of 
	else {
		//Gather RSO here
		$sql = "SELECT U.RSO_ID FROM users U WHERE U.UID = ?";
		$stmt = $conn->prepare($sql);
		$stmt->bind_param("s", $RSO_ID);
		$stmt->execute();
		$rso_id_result = $stmt->get_result();
		$rsoarray = mysqli_fetch_row($rso_id_result);
		
		//Fetch RSO events they can see
		$sql = "SELECT * FROM events E WHERE E.Events_ID IN 
			(SELECT E1.Events_ID FROM events E1, rso_events R WHERE R.Events_ID = E1.Events_ID AND R.RSO_ID = ?);";
		$stmt = $conn->prepare($sql);
		$stmt->bind_param("s", $rso_id);
		$stmt->execute();
		$result = $stmt->get_result();
		$array = mysqli_fetch_all($result, MYSQLI_NUM);
		
		//Fetch public events (everyone can see)
		$sql = "SELECT * FROM events E WHERE E.Events_ID IN
			(SELECT E1.Events_ID FROM events E1, public_events P WHERE E1.Events_ID = P.Events_ID);";
		$result2 = mysqli_query($conn, $sql);
		$array2 = mysqli_fetch_all($result2, MYSQLI_NUM);
		$result_arr = array_merge($array, $array2);
		
		//Fetch private events for university (still everyone can see bc there is no implementation for
		//events of other universities yet)
		$sql = "SELECT * FROM events E WHERE E.Events_ID IN
			(SELECT E1.Events_ID FROM events E1, private_events P WHERE E1.Events_ID = P.Events_ID);";
		$result3 = mysqli_query($conn, $sql);
		$array3 = mysqli_fetch_all($result, MYSQLI_NUM);
		$result_arr = array_merge($result_arr, $array3);
		return json_encode($result_arr);
	}
}
?>
