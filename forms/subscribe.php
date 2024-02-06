<?php
// Retrieve the email from the form
$email = $_POST['email'];

// Validate the email address
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    die("Invalid email format");
}

// Connect to the database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "camdennews";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Insert the email into the subscribers table
$sql = "INSERT INTO subscribers (email) VALUES ('$email')";
if ($conn->query($sql) === TRUE) {
    echo "Thank you for subscribing to Camden Dairy Farm news! To unsubscribe, click here";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

// Close the database connection
$conn->close();
?>

<a href ="Camden Dairy Farm/unsubscribe.php"