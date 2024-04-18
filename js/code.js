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

function showAddEventForm() {
  var form = document.getElementById("addContactForm");
  form.style.display = form.style.display === "none" ? "block" : "none";
}

function addContact() {
  let firstName = document.getElementById("newFirstName").value;
  let lastName = document.getElementById("newLastName").value;
  let email = document.getElementById("newEmail").value;
  let phone = document.getElementById("newPhoneNumber").value;
  let address = document.getElementById("newAddress").value;

  // Read the userId from the cookie
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

  let jsonPayload = {
    id: userId,
    firstName: firstName,
    lastName: lastName,
    email: email,
    phone: phone,
    address: address,
  };

  let xhr = new XMLHttpRequest();
  xhr.open("POST", urlBase + "/Contacts.php?action=addContact", true);
  xhr.setRequestHeader("Content-type", "application/json; charset=UTF-8");

  xhr.onreadystatechange = function () {
    if (this.readyState === 4 && this.status === 200) {
      let response = JSON.parse(xhr.responseText);
      if (response.success) {
        //alert(response.success);
        displayContacts();
      } else {
        alert(response.error);
      }
    }
  };

  xhr.send(JSON.stringify(jsonPayload));

  // Clear the form fields
  document.getElementById("newFirstName").value = "";
  document.getElementById("newLastName").value = "";
  document.getElementById("newEmail").value = "";
  document.getElementById("newPhoneNumber").value = "";
  document.getElementById("newAddress").value = "";

  // Close the form
  document.getElementById("addContactForm").style.display = "none";
}

function displayContacts() {
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

  let xhr = new XMLHttpRequest();
  xhr.open(
    "GET",
    `${urlBase}/Contacts.php?action=getContacts&id=${userId}`,
    true
  );

  xhr.onreadystatechange = function () {
    if (this.readyState === 4 && this.status === 200) {
      let contacts = JSON.parse(xhr.responseText);

      let tableBody = document.getElementById("contactTableBody");
      tableBody.innerHTML = ""; // Clear existing data

      for (let i = 0; i < contacts.length; i++) {
        let contact = contacts[i];
        let row = document.createElement("tr");

        let columns = [
          "firstName",
          "lastName",
          "email",
          "phone",
          "address",
          "actions",
        ]; // Add actions column

        for (let j = 0; j < columns.length; j++) {
          let column = columns[j];
          let cell = document.createElement("td");

          if (column === "actions") {
            // Create edit and delete buttons
            let editButton = document.createElement("button");
            editButton.textContent = "Edit";
            editButton.addEventListener("click", function () {
              editContact(contact);
            });

            let deleteButton = document.createElement("button");
            deleteButton.textContent = "Delete";
            deleteButton.addEventListener("click", function () {
              deleteContact(contact.contact_id);
            });

            cell.appendChild(editButton);
            cell.appendChild(deleteButton);
          } else {
            cell.textContent = contact[column];
          }

          row.appendChild(cell);
        }

        tableBody.appendChild(row);
      }
    }
  };
  xhr.send();
}

// Add functions to handle edit and delete actions
function editContact(contact) {
  contactIdGlobal = contact.contact_id;

  if (contact) {
    document.getElementById("editFirstName").value = contact.firstName;
    document.getElementById("editLastName").value = contact.lastName;
    document.getElementById("editEmail").value = contact.email;
    document.getElementById("editPhoneNumber").value = contact.phone;
    document.getElementById("editAddress").value = contact.address;

    document.getElementById("editContactForm").style.display = "block";
  }
}

function updateContact() {
  let firstName = document.getElementById("editFirstName").value;
  let lastName = document.getElementById("editLastName").value;
  let email = document.getElementById("editEmail").value;
  let phone = document.getElementById("editPhoneNumber").value;
  let address = document.getElementById("editAddress").value;

  let jsonPayload = {
    contact_id: contactIdGlobal,
    firstName: firstName,
    lastName: lastName,
    email: email,
    phone: phone,
    address: address,
  };

  let xhr = new XMLHttpRequest();
  xhr.open("POST", urlBase + "/Contacts.php?action=updateContact", true);
  xhr.setRequestHeader("Content-type", "application/json; charset=UTF-8");

  xhr.onreadystatechange = function () {
    if (this.readyState === 4 && this.status === 200) {
      let response = JSON.parse(xhr.responseText);
      if (response.success) {
        //alert(response.success);
        displayContacts();
      } else {
        alert(response.error);
      }
    }
  }

  xhr.send(JSON.stringify(jsonPayload));

  // Hide the edit form after updating
  document.getElementById("editContactForm").style.display = "none";
}

function deleteContact(contactId) {
  console.log(contactId);
  let url = `${urlBase}/Contacts.php?action=deleteContactById`;
  let jsonPayload = JSON.stringify({ contact_id: contactId });

  let xhr = new XMLHttpRequest();
  xhr.open("POST", url, true);
  xhr.setRequestHeader("Content-type", "application/json; charset=UTF-8");

  xhr.onreadystatechange = function () {
    if (this.readyState === 4 && this.status === 200) {
      let response = JSON.parse(xhr.responseText);
      if (response.success) {
        //alert(response.success);
        displayContacts();
      } else {
        alert(response.error);
      }
    }
  };
  xhr.send(jsonPayload);
}

function searchContacts() {
  let query = document.getElementById("searchContact").value;
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

  let xhr = new XMLHttpRequest();
  xhr.open(
    "GET",
    `${urlBase}/Contacts.php?action=getContacts&id=${userId}`,
    true
  );

  xhr.onreadystatechange = function () {
    if (this.readyState === 4 && this.status === 200) {
      let contacts = JSON.parse(xhr.responseText);

      let tableBody = document.getElementById("contactTableBody");
      tableBody.innerHTML = ""; // Clear existing data

      for (let i = 0; i < contacts.length; i++) {
        let contact = contacts[i];
        let row = document.createElement("tr");

        let columns = [
          "firstName",
          "lastName",
          "email",
          "phone",
          "address",
          "actions",
        ]; // Add actions column

        for (let j = 0; j < columns.length; j++) {
          let column = columns[j];
          let cell = document.createElement("td");

          if (column === "actions") {
            let editButton = document.createElement("button");
            editButton.textContent = "Edit";
            editButton.addEventListener("click", function () {
              editContact(contact.id);
            });

            let deleteButton = document.createElement("button");
            deleteButton.textContent = "Delete";
            deleteButton.addEventListener("click", function () {
              deleteContact(contact.id);
            });

            cell.appendChild(editButton);
            cell.appendChild(deleteButton);
          } else {
            cell.textContent = contact[column];
          }

          row.appendChild(cell);
        }

        if (
          contact.firstName.includes(query) ||
          contact.lastName.includes(query) ||
          contact.email.includes(query) ||
          contact.phone.includes(query) ||
          contact.address.includes(query)
        ) {
          tableBody.appendChild(row);
        }
      }
    }
  };
  xhr.send();
}
