<?php

function addUser($password, $name) {
$stmt = $conn->prepare("INSERT INTO users (pass, name) VALUES (?)");
$stmt->bind_param("ss", $password, $name);
$stmt->execute();
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

function verifyLogin($conn, $uid, $pass) {
$sql = "SELECT * FROM users WHERE UID = ? AND pass = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $uid, $pass);
$stmt->execute();
$result = $stmt->get_result();
$array = mysqli_fetch_all($result, MYSQLI_ASSOC);
printf("result is: %s", $array[0]["name"]);
}

?>