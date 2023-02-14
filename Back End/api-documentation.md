###[API Documentation]

####[CRUD]

#####/api/create.php
**What To Send:** session, task, tag, start, end
**Example Query:** /api/create.php?session=8sInzfoMNUoJyaS5S0zN7uBcS1A6YHnxJ38imK8b4ScxChAUxaLZNHClNp2P05KI&task=test&tag=test&start=2/14/23&end=2/15/23
**What it Returns:** If it was created successfully it will return a "Created" string.

#####/api/read.php
**What To Send:** session, task, tag, start, end
**Example Query:** /api/read.php?session=8sInzfoMNUoJyaS5S0zN7uBcS1A6YHnxJ38imK8b4ScxChAUxaLZNHClNp2P05KI
**What it Returns:** If it was created successfully it will return a "Created" string.

#####/api/update.php
**What To Send:** session
**Example Query:** /api/update.php?session=8sInzfoMNUoJyaS5S0zN7uBcS1A6YHnxJ38imK8b4ScxChAUxaLZNHClNp2P05KI&id=2&task=test&tag=tested
**What it Returns:** If it was read successfully it will return a json of habits.
**Example Output:** [{"id":"2","uid":"1","task":"test","tag":"test","start":"2023-02-14 00:00:00","end":"2023-02-15 00:00:00","created":"2023-02-14 19:23:28"}]

#####/api/delete.php
**What To Send:** session, id
**Example Query:** /api/delete.php?session=8sInzfoMNUoJyaS5S0zN7uBcS1A6YHnxJ38imK8b4ScxChAUxaLZNHClNp2P05KI&id=1
**What it Returns:** If it was deleted successfully it will return a "Deleted" string.

####[AUTH]

#####/api/auth.php
**What To Send:** username, password **OR** session
**Example Query (Username & Password):** /api/auth.php?username=TestCustomer&password=Test
**Example Query (Session):** /api/auth.php?session=8sInzfoMNUoJyaS5S0zN7uBcS1A6YHnxJ38imK8b4ScxChAUxaLZNHClNp2P05KI
**What it Returns:** If the login was successful both login methods will return a json of the user data. The Username & Password method will also return a session token to save for future logins.
**Example Output (Username & Password):** [{"id":"1","username":"TestCustomer","email":"Test@Test.com","created":"2023-02-14 17:53:54","session":"8sInzfoMNUoJyaS5S0zN7uBcS1A6YHnxJ38imK8b4ScxChAUxaLZNHClNp2P05KI"}]
**Example Output (Session):**[{"id":"1","username":"TestCustomer","email":"Test@Test.com","created":"2023-02-14 17:53:54"}]

