const urlBase = "/db_actions.php";
const extension = "php";

let userId = 0;
let firstName = "";
let lastName = "";
let contactIdGlobal = 0;

function doRegister() {
  let email = document.getElementById("loginName").value;
  let password = document.getElementById("loginPassword").value;
  //let firstName = document.getElementById("firstName").value;
  //let lastName = document.getElementById("lastName").value;

  document.getElementById("loginResult").innerHTML = "";

  let tmp = {
    email: email,
    password: password,
  };
  let jsonPayload = JSON.stringify(tmp);

  let url = urlBase + "?action=addUser";

  let xhr = new XMLHttpRequest();
  xhr.open("POST", url, true);
  xhr.setRequestHeader("Content-type", "application/json; charset=UTF-8");
  try {
    xhr.onreadystatechange = function () {
      if (this.readyState === 4 && this.status === 200) {
        let jsonObject = JSON.parse(xhr.responseText);
        userId = jsonObject.id;

        if (userId < 1) {
          document.getElementById("loginResult").innerHTML =
            "Registration failed. Please try again.";
          return;
        }

        firstName = jsonObject.firstName;
        lastName = jsonObject.lastName;

        saveCookie();

        window.location.href = "./";
      }
    };
    xhr.send(jsonPayload);
  } catch (err) {
    document.getElementById("loginResult").innerHTML = err.message;
  }
}

function doLogin() {
  userId = 0;
  firstName = "";
  lastName = "";

  let email = document.getElementById("loginName").value;
  let password = document.getElementById("loginPassword").value;
  // var hash = md5( password );

  document.getElementById("loginResult").innerHTML = "";

  let tmp = { email: email, password: password };
  // var tmp = {login:login,password:hash};
  let jsonPayload = JSON.stringify(tmp);

  let url = urlBase + "?action=verifyLogin";

  let xhr = new XMLHttpRequest();
  xhr.open("POST", url, true);
  xhr.setRequestHeader("Content-type", "application/json; charset=UTF-8");
  try {
    xhr.onreadystatechange = function () {
      if (this.readyState === 4 && this.status === 200) {
        let jsonObject = JSON.parse(xhr.responseText);
        userId = jsonObject.id;

        if (userId < 1) {
          document.getElementById("loginResult").innerHTML =
            "Email/Password combination incorrect";
          return;
        }

        saveCookie();

        window.location.href = "events.html";
      }
    };
    xhr.send(jsonPayload);
  } catch (err) {
    document.getElementById("loginResult").innerHTML = err.message;
  }
}

function displayEvents() {
  let userId = -1;
  let data = document.cookie;
  let splits = data.split(",");
  for (var i = 0; i < splits.length; i++) {
    let thisOne = splits[i].trim();
    let tokens = thisOne.split("=");
    if (tokens[0] === "userId") {
      userId = parseInt(tokens[1].trim());
    }
  }

  console.log(userId);
  let url = urlBase + "?action=viewEvents&userId=" + userId;


  let xhr = new XMLHttpRequest();
  xhr.open("GET", url, true);

  xhr.onreadystatechange = function () {
    if (this.readyState === 4 && this.status === 200) {
      //console.log(xhr.responseText);
      let events = JSON.parse(xhr.responseText);
      let tableBody = document.getElementById("contactTableBody");
      tableBody.innerHTML = ""; // Clear existing data

      for (let i = 0; i < events.length; i++) {
        let event = events[i];
        let row = document.createElement("tr");
        console.log(event);
        let columns = [
          "Event_Name",
          "Category",
          "Description",
          "Time",
          "Location",
          "Phone",
          "Email",
          "actions",
        ]; // Add actions column

        for (let j = 0; j < columns.length; j++) {
          let column = columns[j];
          let cell = document.createElement("td");
          //console.log(column);
          if (column === "actions") {
            // Create edit and delete buttons
            let editButton = document.createElement("button");
            editButton.textContent = "Edit";
            editButton.addEventListener("click", function () {
              editContact(event);
            });

            cell.appendChild(editButton);
          } else if(column === "Event_Name") {
            cell.textContent = event[3];
            //console.log(event[column])
          }else if(column === "Category") {
            cell.textContent = event[0];
            //console.log(event[column])
          }else if(column === "Description") {
            cell.textContent = event[4];
            //console.log(event[column])
          }else if(column === "Time") {
            cell.textContent = event[1];
            //console.log(event[column])
          }else if(column === "Location") {
            cell.textContent = event[2];
            //console.log(event[column])
          }else if(column === "Phone") {
            cell.textContent = event[0];
            //console.log(event[column])
          }else if(column === "Email") {
            cell.textContent = event[0];
            //console.log(event[column])
          }

          row.appendChild(cell);
        }

        tableBody.appendChild(row);
      }
    }
  };
  xhr.send();
}

function doLogOut() {
  userId = 0;
  email = "";
  saveCookie(email);
}

function saveCookie(tempemail) {
  let minutes = 20;
  let date = new Date();
  date.setTime(date.getTime() + minutes * 60 * 1000);
  console.log(userId);
  console.log(tempemail);
  document.cookie =
    "email=" +
    tempemail +
    ",userId=" +
    userId +
    ";expires=" +
    date.toGMTString();
}

function readCookie() {
  console.log(userId);
  console.log(email);
  email = "";
  userId = -1;
  let data = document.cookie;
  console.log(data);
  let splits = data.split(",");
  for (var i = 0; i < splits.length; i++) {
    let thisOne = splits[i].trim();
    let tokens = thisOne.split("=");
    if (tokens[0] === "email") {
      console.log("FN");
      email = tokens[1];
      console.log(tokens[1]);
    } else if (tokens[0] === "userId") {
      userId = parseInt(tokens[1].trim());
    }
    console.log(email);
  }

  if (userId < 0) {
    window.location.href = "./";
  } else {
    document.getElementById("welcomeMessage").textContent =
      "Welcome, " + email + " " + userId + "!";
    //print out the user id to the console
    console.log(userId);
  }
}

function getMembers() {
  //set up HTML reference
  rso_id = 1;
  let ref = document.querySelector("memberTableBody")
  let data = "";

  //get members
  let xhr = new XMLHttpRequest();
  xhr.open(
    "GET",
    `${urlBase}?action=viewUsers&RSO_ID=${rso_id}`,
    true
  );
  xhr.onreadystatechange = function () {
    if (this.readyState === 4 && this.status === 200) {
      let members = JSON.parse(xhr.responseText);

      console.log(members);

      for (let i = 0; i < members.length; i++) {
        data += "<tr><td>"+members.name+"</td><td>User</td></tr>";
      }
    }
  }
  console.log("data:"+data);
  xhr.send(); // Send the request

  let xhr2 = new XMLHttpRequest();
  xhr2.open("GET", `${urlBase}?action=viewAdmins&RSO_ID=${rso_id}`, true);
  xhr2.onreadystatechange = function () {
    if (this.readyState === 4 && this.status === 200) {
      let admins = JSON.parse(xhr2.responseText);

      for (let i = 0; i < admins.length; i++) {
        let admin_id = admins[i].admin_id;

        data += "<tr>"

        let xhr3 = new XMLHttpRequest();
        xhr3.open("GET", `${urlBase}?action=getNameFromAdmin&adminId=${admin_id}`, true);
        xhr3.onreadystatechange = function () {
          if (this.readyState === 4 && this.status === 200) {
            let admin_name = JSON.parse(xhr3.responseText);

            data += "<td>"+admin_name.name+
            "</td><td>admin</td></tr>";
          }
        }
        xhr3.send();
      }
    }
  }
  xhr2.send(); // Send the request

  ref.innerHTML = data;
}