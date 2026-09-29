import 'package:flutter/material.dart';

void main() {
 runApp(const BusGoApp());
}

// ============================================================
// COLORS
// ============================================================

const Color mainRed = Color(0xffE53935);
const Color darkRed = Color(0xffB71C1C);
const Color lightRed = Color(0xffffebee);
const Color appBackground = Color(0xffF7F7F7);

// ============================================================
// APP
// ============================================================

class BusGoApp extends StatelessWidget {
 const BusGoApp({super.key});

 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     title: 'BusGo',
     theme: ThemeData(
       useMaterial3: true,
       scaffoldBackgroundColor: appBackground,
       colorScheme: ColorScheme.fromSeed(
          seedColor: mainRed,
       ),
     ),
     home: const LoginPage(),
   );
 }
}

// ============================================================
// HELPER FUNCTIONS
// ============================================================

String formatDate(DateTime date) {
 const months = [
   'Jan',

      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
 ];

 return '${date.day} ${months[date.month - 1]} ${date.year}';
}

// ------------------------------------------------------------
// PNR GENERATOR
// ------------------------------------------------------------

int pnrCounter = 450125;

String generatePNR() {
 pnrCounter++;
 return 'BG$pnrCounter';
}

// ------------------------------------------------------------
// MESSAGE
// ------------------------------------------------------------

void showMessage(BuildContext context, String message) {
 ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ),
 );
}

// ------------------------------------------------------------
// BERTH LOGIC
// ------------------------------------------------------------
//
// IMPORTANT:
//
// Seat is selected FIRST.

// Then berth is automatically decided.
//
// For 20 seats:
// 1 - 10 = Lower
// 11 - 20 = Upper
//
// For 8 seats:
// 1 - 4   = Lower
// 5 - 8   = Upper
//
// So user cannot randomly select berth for a seat.
// ------------------------------------------------------------

String getBerth(int seat, int capacity) {
 int half = capacity ~/ 2;

 if (seat <= half) {
   return 'Lower';
 }

 return 'Upper';
}

// ============================================================
// BUS MODEL
// ============================================================

class Bus {
 String name;
 String from;
 String to;
 String departure;
 String arrival;
 String type;
 int price;
 String boarding;
 String dropping;
 int capacity;

 Bus({
   required this.name,
   required this.from,
   required this.to,
   required this.departure,
   required this.arrival,
   required this.type,
   required this.price,

   required this.boarding,
   required this.dropping,
   required this.capacity,
 });
}

// ============================================================
// BOOKING MODEL
// ============================================================

class Booking {
 String pnr;
 String passengerName;
 String mobile;
 String busName;
 String from;
 String to;
 String date;
 String departure;
 String arrival;
 int seat;
 String berth;
 String busType;
 String boarding;
 String dropping;
 int fare;
 String paymentMethod;
 String status;

 Booking({
   required this.pnr,
   required this.passengerName,
   required this.mobile,
   required this.busName,
   required this.from,
   required this.to,
   required this.date,
   required this.departure,
   required this.arrival,
   required this.seat,
   required this.berth,
   required this.busType,
   required this.boarding,
   required this.dropping,
   required this.fare,
   required this.paymentMethod,
   required this.status,

 });
}

// ============================================================
// DEMO BOOKINGS
// ============================================================
//
// These bookings are already present so that you can demonstrate
// booked seats to your teacher.
//
// Mumbai -> Pune
// ============================================================

List<Booking> bookings = [
 Booking(
    pnr: 'BG450123',
    passengerName: 'Rahul Sharma',
    mobile: '9876543210',
    busName: 'Neeta Travels',
    from: 'Mumbai',
    to: 'Pune',
    date: formatDate(DateTime.now()),
    departure: '08:30 AM',
    arrival: '12:30 PM',
    seat: 3,
    berth: 'Lower',
    busType: 'AC Sleeper',
    boarding: 'Dadar East',
    dropping: 'Pune Station',
    fare: 650,
    paymentMethod: 'UPI',
    status: 'CONFIRMED',
 ),

 Booking(
   pnr: 'BG450124',
   passengerName: 'Sneha Patil',
   mobile: '9876501234',
   busName: 'VRL Travels',
   from: 'Mumbai',
   to: 'Pune',
   date: formatDate(DateTime.now()),
   departure: '10:00 AM',
   arrival: '02:00 PM',
   seat: 7,
   berth: 'Lower',
   busType: 'AC Sleeper',

      boarding: 'Sion Circle',
      dropping: 'Swargate',
      fare: 750,
      paymentMethod: 'Card',
      status: 'CONFIRMED',
 ),

 Booking(
    pnr: 'BG450125',
    passengerName: 'Amit Patil',
    mobile: '9876501111',
    busName: 'Shivneri Express',
    from: 'Mumbai',
    to: 'Pune',
    date: formatDate(DateTime.now()),
    departure: '07:00 AM',
    arrival: '11:30 AM',
    seat: 1,
    berth: 'Lower',
    busType: 'AC Sleeper',
    boarding: 'Dadar East',
    dropping: 'Pune Station',
    fare: 550,
    paymentMethod: 'Cash',
    status: 'CONFIRMED',
 ),
];

// ============================================================
// ============================================================
// LOGIN PAGE
// ============================================================

class LoginPage extends StatefulWidget {
 const LoginPage({super.key});

 @override
 State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
 final TextEditingController emailController =
 TextEditingController();

 final TextEditingController passwordController =
 TextEditingController();

bool hidePassword = true;

void login() {
  String email = emailController.text.trim();
  String password = passwordController.text;

    // EMAIL VALIDATION
    if (email.isEmpty) {
      showMessage(context, 'Please enter your email');
      return;
    }

    final emailRegex =
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailRegex.hasMatch(email)) {
      showMessage(context, 'Please enter a valid email address');
      return;
    }

    // PASSWORD VALIDATION
    if (password.isEmpty) {
      showMessage(context, 'Please enter your password');
      return;
    }

    // CHECK REGISTERED ACCOUNT
    if (registeredEmail == null ||
        registeredPassword == null ||
        email.toLowerCase() != registeredEmail!.toLowerCase() ||
        password != registeredPassword) {
      showMessage(
        context,
        'Invalid email or password. Please register first.',
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(username: registeredName!),
      ),
    );
}

@override

void dispose() {
  emailController.dispose();
  passwordController.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: mainRed,
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Container(
                height: 95,
                width: 95,
                decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                   Icons.directions_bus,
                   color: mainRed,
                   size: 55,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'BusGo',
                style: TextStyle(
                   color: Colors.white,
                   fontSize: 34,
                   fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                'Travel smart. Travel easy.',
                style: TextStyle(
                   color: Colors.white70,
                   fontSize: 15,
                ),

),

const SizedBox(height: 40),

Container(
  padding: const EdgeInsets.all(22),
  decoration: BoxDecoration(
     color: Colors.white,
     borderRadius: BorderRadius.circular(25),
  ),
  child: Column(
     children: [
       const Text(
          'Login',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
       ),

      const SizedBox(height: 25),

      TextField(
         controller: emailController,
         keyboardType:
         TextInputType.emailAddress,
         decoration: InputDecoration(
           prefixIcon:
           const Icon(Icons.email),
           labelText: 'Email',
           hintText: 'example@gmail.com',
           border: OutlineInputBorder(
             borderRadius:
             BorderRadius.circular(15),
           ),
         ),
      ),

      const SizedBox(height: 15),

      TextField(
        controller: passwordController,
        obscureText: hidePassword,
        decoration: InputDecoration(
          prefixIcon:
          const Icon(Icons.lock),
          suffixIcon: IconButton(

         onPressed: () {
            setState(() {
              hidePassword =
              !hidePassword;
            });
         },
         icon: Icon(
            hidePassword
                ? Icons.visibility
                : Icons.visibility_off,
         ),
       ),
       labelText: 'Password',
       border: OutlineInputBorder(
         borderRadius:
         BorderRadius.circular(15),
       ),
     ),
),

const SizedBox(height: 25),

SizedBox(
   width: double.infinity,
   height: 52,
   child: ElevatedButton(
     onPressed: login,
     style: ElevatedButton.styleFrom(
       backgroundColor: mainRed,
       foregroundColor: Colors.white,
       shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(15),
       ),
     ),
     child: const Text(
       'LOGIN',
       style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
       ),
     ),
   ),
),

const SizedBox(height: 18),

                                Row(
                                   mainAxisAlignment:
                                   MainAxisAlignment.center,
                                   children: [
                                     const Text(
                                       "Don't have an account? ",
                                       style: TextStyle(
                                          color: Colors.grey,
                                       ),
                                     ),
                                     TextButton(
                                       onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                               builder: (_) =>
                                               const RegisterPage(),
                                            ),
                                          );
                                       },
                                       child: const Text(
                                          'Register',
                                          style: TextStyle(
                                            color: mainRed,
                                            fontWeight: FontWeight.bold,
                                          ),
                                       ),
                                     ),
                                   ],
                                ),
                              ],
                         ),
                       ),
                  ],
                ),
              ),
         ),
       ),
     );
 }
}

// ============================================================
// REGISTERED USER DATA
// ============================================================

// Simple in-memory account for this college project.

// It works during the current app session.
String? registeredName;
String? registeredEmail;
String? registeredPassword;

// ============================================================
// REGISTER PAGE
// ============================================================

class RegisterPage extends StatefulWidget {
 const RegisterPage({super.key});

 @override
 State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
 final TextEditingController nameController =
 TextEditingController();

 final TextEditingController emailController =
 TextEditingController();

 final TextEditingController passwordController =
 TextEditingController();

 final TextEditingController confirmPasswordController =
 TextEditingController();

 bool hidePassword = true;
 bool hideConfirmPassword = true;

 void register() {
   String name = nameController.text.trim();
   String email = emailController.text.trim();
   String password = passwordController.text;
   String confirmPassword =
       confirmPasswordController.text;

   // NAME VALIDATION
   if (name.isEmpty) {
     showMessage(context, 'Please enter your name');
     return;
   }

   if (name.length < 2) {
     showMessage(

      context,
      'Name must contain at least 2 characters',
    );
    return;
}

final nameRegex = RegExp(r'^[a-zA-Z ]+$');

if (!nameRegex.hasMatch(name)) {
  showMessage(
    context,
    'Name can contain only letters and spaces',
  );
  return;
}

// EMAIL VALIDATION
if (email.isEmpty) {
  showMessage(context, 'Please enter your email');
  return;
}

final emailRegex =
RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

if (!emailRegex.hasMatch(email)) {
  showMessage(
    context,
    'Please enter a valid email address',
  );
  return;
}

// PASSWORD VALIDATION
if (password.isEmpty) {
  showMessage(context, 'Please enter password');
  return;
}

if (password.length < 6) {
  showMessage(
    context,
    'Password must be at least 6 characters',
  );
  return;
}

    // CONFIRM PASSWORD VALIDATION
    if (confirmPassword.isEmpty) {
      showMessage(
        context,
        'Please confirm your password',
      );
      return;
    }

    if (password != confirmPassword) {
      showMessage(
        context,
        'Password and confirm password do not match',
      );
      return;
    }

    // SAVE ACCOUNT
    registeredName = name;
    registeredEmail = email;
    registeredPassword = password;

    showMessage(
      context,
      'Registration successful! Please login.',
    );

    Navigator.pop(context);
}

@override
void dispose() {
  nameController.dispose();
  emailController.dispose();
  passwordController.dispose();
  confirmPasswordController.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: mainRed,
    appBar: AppBar(
      backgroundColor: mainRed,
      foregroundColor: Colors.white,
      title: const Text(

    'Create Account',
    style: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
),
body: SafeArea(
  child: SingleChildScrollView(
     padding: const EdgeInsets.all(25),
     child: Container(
       padding: const EdgeInsets.all(22),
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(25),
       ),
       child: Column(
         children: [
           const Icon(
             Icons.person_add,
             color: mainRed,
             size: 65,
           ),

          const SizedBox(height: 10),

          const Text(
            'Register',
            style: TextStyle(
               fontSize: 28,
               fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          TextField(
            controller: nameController,
            textCapitalization:
            TextCapitalization.words,
            decoration: InputDecoration(
              prefixIcon:
              const Icon(Icons.person),
              labelText: 'Full Name',
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(15),
              ),

  ),
),

const SizedBox(height: 15),

TextField(
  controller: emailController,
  keyboardType:
  TextInputType.emailAddress,
  decoration: InputDecoration(
     prefixIcon:
     const Icon(Icons.email),
     labelText: 'Email',
     hintText: 'example@gmail.com',
     border: OutlineInputBorder(
       borderRadius:
       BorderRadius.circular(15),
     ),
  ),
),

const SizedBox(height: 15),

TextField(
  controller: passwordController,
  obscureText: hidePassword,
  decoration: InputDecoration(
    prefixIcon:
    const Icon(Icons.lock),
    suffixIcon: IconButton(
      onPressed: () {
         setState(() {
           hidePassword =
           !hidePassword;
         });
      },
      icon: Icon(
         hidePassword
             ? Icons.visibility
             : Icons.visibility_off,
      ),
    ),
    labelText: 'Password',
    border: OutlineInputBorder(
      borderRadius:
      BorderRadius.circular(15),
    ),

  ),
),

const SizedBox(height: 15),

TextField(
  controller:
  confirmPasswordController,
  obscureText: hideConfirmPassword,
  decoration: InputDecoration(
     prefixIcon:
     const Icon(Icons.lock_outline),
     suffixIcon: IconButton(
       onPressed: () {
          setState(() {
            hideConfirmPassword =
            !hideConfirmPassword;
          });
       },
       icon: Icon(
          hideConfirmPassword
              ? Icons.visibility
              : Icons.visibility_off,
       ),
     ),
     labelText: 'Confirm Password',
     border: OutlineInputBorder(
       borderRadius:
       BorderRadius.circular(15),
     ),
  ),
),

const SizedBox(height: 25),

SizedBox(
  width: double.infinity,
  height: 52,
  child: ElevatedButton(
    onPressed: register,
    style: ElevatedButton.styleFrom(
      backgroundColor: mainRed,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
         borderRadius:
         BorderRadius.circular(15),
      ),

                              ),
                              child: const Text(
                                'CREATE ACCOUNT',
                                style: TextStyle(
                                   fontSize: 16,
                                   fontWeight: FontWeight.bold,
                                ),
                              ),
                         ),
                       ),

                       const SizedBox(height: 10),

                       TextButton(
                         onPressed: () {
                            Navigator.pop(context);
                         },
                         child: const Text(
                            'Already have an account? Login',
                            style: TextStyle(
                              color: mainRed,
                              fontWeight: FontWeight.bold,
                            ),
                         ),
                       ),
                  ],
                ),
              ),
         ),
       ),
     );
 }
}

// HOME PAGE
// ============================================================

class HomePage extends StatefulWidget {
 final String username;

 const HomePage({
   super.key,
   required this.username,
 });

 @override
 State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
 String from = 'Mumbai';
 String to = 'Pune';

DateTime selectedDate = DateTime.now();

void logout() {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const LoginPage(),
    ),
        (route) => false,
  );
}

Future<void> selectDate() async {
  DateTime? date = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(
      const Duration(days: 90),
    ),
  );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
}

void searchBus() {
  if (from == to) {
    showMessage(
      context,
      'From and To cannot be same',
    );
    return;
  }

    Navigator.push(
      context,
      MaterialPageRoute(

        builder: (_) => BusListPage(
           from: from,
           to: to,
           date: selectedDate,
        ),
      ),
    );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: mainRed,
      foregroundColor: Colors.white,
      title: Text(
         'Hello, ${widget.username}',
         style: const TextStyle(
           fontWeight: FontWeight.bold,
           fontSize: 20,
         ),
      ),
      actions: [
         IconButton(
           tooltip: 'My Bookings',
           onPressed: () {
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const MyBookingsPage(),
                ),
             );
           },
           icon: const Icon(
             Icons.confirmation_number,
           ),
         ),
         IconButton(
           tooltip: 'Logout',
           onPressed: logout,
           icon: const Icon(
             Icons.logout,
           ),
         ),
      ],
    ),

body: SingleChildScrollView(
  child: Column(
    children: [
      // ------------------------------------------------
      // BANNER
      // ------------------------------------------------

     Container(
       height: 210,
       width: double.infinity,
       color: darkRed,
       child: Stack(
         children: [
           const Center(
              child: Icon(
                Icons.directions_bus,
                color: Colors.white,
                size: 110,
              ),
           ),

           Positioned(
              left: 22,
              bottom: 22,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: const [
                   Text(
                     'Travel Smart',
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 30,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                   Text(
                     'Book your bus in a few taps',
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 16,
                     ),
                   ),
                ],
              ),
           ),

       ],
  ),
),

// ------------------------------------------------
// SEARCH
// ------------------------------------------------

Padding(
  padding: const EdgeInsets.all(18),
  child: Column(
    children: [
      Align(
         alignment: Alignment.centerLeft,

                                        👋
         child: Text(
           'Hello, ${widget.username}    ',
           style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
           ),
         ),
      ),

        const SizedBox(height: 5),

        const Align(
           alignment: Alignment.centerLeft,
           child: Text(
             'Search Buses',
             style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
             ),
           ),
        ),

        const SizedBox(height: 18),

        // FROM
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(15),

       border: Border.all(
          color: Colors.grey.shade300,
       ),
     ),
     child: DropdownButtonHideUnderline(
       child: DropdownButton<String>(
          isExpanded: true,
          value: from,
          items: const [
            DropdownMenuItem(
              value: 'Mumbai',
              child: Text('Mumbai'),
            ),
            DropdownMenuItem(
              value: 'Thane',
              child: Text('Thane'),
            ),
            DropdownMenuItem(
              value: 'Navi Mumbai',
              child:
              Text('Navi Mumbai'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              from = value!;
            });
          },
       ),
     ),
),

const SizedBox(height: 12),

// TO
Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 15,
  ),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius:
    BorderRadius.circular(15),
    border: Border.all(
       color: Colors.grey.shade300,
    ),
  ),

     child: DropdownButtonHideUnderline(
       child: DropdownButton<String>(
          isExpanded: true,
          value: to,
          items: const [
            DropdownMenuItem(
              value: 'Pune',
              child: Text('Pune'),
            ),
            DropdownMenuItem(
              value: 'Nashik',
              child: Text('Nashik'),
            ),
            DropdownMenuItem(
              value: 'Kolhapur',
              child: Text('Kolhapur'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              to = value!;
            });
          },
       ),
     ),
),

const SizedBox(height: 12),

// DATE
InkWell(
  onTap: selectDate,
  child: Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
       color: Colors.white,
       borderRadius:
       BorderRadius.circular(15),
       border: Border.all(
         color: Colors.grey.shade300,
       ),
    ),
    child: Row(
       children: [
         const Icon(
           Icons.calendar_month,
           color: mainRed,

                              ),
                              const SizedBox(width: 12),
                              Text(
                                formatDate(selectedDate),
                                style: const TextStyle(
                                   fontSize: 16,
                                   fontWeight:
                                   FontWeight.w600,
                                ),
                              ),
                            ],
                       ),
                     ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                   width: double.infinity,
                   height: 55,
                   child: ElevatedButton.icon(
                     onPressed: searchBus,
                     icon: const Icon(
                        Icons.search,
                     ),
                     label: const Text(
                        'SEARCH BUSES',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                     ),
                     style: ElevatedButton.styleFrom(
                        backgroundColor: mainRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                     ),
                   ),
                ),
              ],
         ),
       ),
     ],
),

       ),
     );
 }
}

// ============================================================
// BUS LIST PAGE
// ============================================================

class BusListPage extends StatelessWidget {
 final String from;
 final String to;
 final DateTime date;

 const BusListPage({
   super.key,
   required this.from,
   required this.to,
   required this.date,
 });

 // ----------------------------------------------------------
 // CREATE BUSES
 // ----------------------------------------------------------

 List<Bus> get buses {
   String boarding1;
   String boarding2;
   String boarding3;

     if (from == 'Mumbai') {
       boarding1 = 'Dadar East';
       boarding2 = 'Sion Circle';
       boarding3 = 'Kurla';
     } else if (from == 'Thane') {
       boarding1 = 'Thane Station';
       boarding2 = 'Teen Hath Naka';
       boarding3 = 'Mulund Check Naka';
     } else {
       boarding1 = 'Vashi Plaza';
       boarding2 = 'CBD Belapur';
       boarding3 = 'Panvel';
     }

     String dropping;

     if (to == 'Pune') {

  dropping = 'Pune Station';
} else if (to == 'Nashik') {
  dropping = 'Nashik CBS';
} else {
  dropping = 'Kolhapur Stand';
}

return [
  Bus(
    name: 'Neeta Travels',
    from: from,
    to: to,
    departure: '08:30 AM',
    arrival: '12:30 PM',
    type: 'AC Sleeper',
    price: 650,
    boarding: boarding1,
    dropping: dropping,
    capacity: 20,
  ),

 Bus(
   name: 'VRL Travels',
   from: from,
   to: to,
   departure: '10:00 AM',
   arrival: '02:00 PM',
   type: 'AC Sleeper',
   price: 750,
   boarding: boarding2,
   dropping: dropping,
   capacity: 20,
 ),

  Bus(
    name: 'Shivneri Express',
    from: from,
    to: to,
    departure: '07:00 AM',
    arrival: '11:30 AM',
    type: 'AC Sleeper',
    price: 550,
    boarding: boarding3,
    dropping: dropping,
    capacity: 8,
  ),
];

}

// ----------------------------------------------------------
// AVAILABLE SEATS
// ----------------------------------------------------------

int getAvailableSeats(Bus bus) {
  String dateText = formatDate(date);

    Set<int> bookedSeats = bookings
        .where(
          (booking) =>
      booking.busName == bus.name &&
          booking.from == bus.from &&
          booking.to == bus.to &&
          booking.date == dateText &&
          booking.status == 'CONFIRMED',
    )
        .map((booking) => booking.seat)
        .toSet();

    return bus.capacity - bookedSeats.length;
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
         '$from → $to',
         style: const TextStyle(
           fontWeight: FontWeight.bold,
         ),
      ),
      backgroundColor: mainRed,
      foregroundColor: Colors.white,
    ),

     body: ListView.builder(
       padding: const EdgeInsets.all(15),
       itemCount: buses.length,
       itemBuilder: (context, index) {
         Bus bus = buses[index];

          int seats = getAvailableSeats(bus);

          return Card(

margin: const EdgeInsets.only(
  bottom: 16,
),
elevation: 3,
shape: RoundedRectangleBorder(
  borderRadius:
  BorderRadius.circular(20),
),
child: Padding(
  padding: const EdgeInsets.all(17),
  child: Column(
    children: [
      Row(
        children: [
           Container(
              padding:
              const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: lightRed,
                borderRadius:
                BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.directions_bus,
                color: mainRed,
                size: 35,
              ),
           ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                   bus.name,
                   style: const TextStyle(
                     fontSize: 18,
                     fontWeight:
                     FontWeight.bold,
                   ),
                ),
                Text(
                   bus.type,
                   style: const TextStyle(

                       color: Colors.grey,
                     ),
                ),
              ],
            ),
       ),

       Text(
          '₹${bus.price}',
          style: const TextStyle(
            fontSize: 19,
            fontWeight:
            FontWeight.bold,
            color: mainRed,
          ),
       ),
     ],
),

const Divider(height: 25),

Row(
  mainAxisAlignment:
  MainAxisAlignment.spaceBetween,
  children: [
     timeColumn(
        bus.departure,
        bus.from,
     ),

       const Icon(
          Icons.arrow_forward,
          color: Colors.grey,
       ),

       timeColumn(
          bus.arrival,
          bus.to,
       ),
     ],
),

const SizedBox(height: 14),

Row(
  children: [
     const Icon(

         Icons.location_on,
         size: 19,
         color: mainRed,
       ),
       const SizedBox(width: 5),
       Expanded(
          child: Text(
            'Boarding: ${bus.boarding}',
          ),
       ),
     ],
),

const SizedBox(height: 5),

Row(
   children: [
     const Icon(
        Icons.flag,
        size: 19,
        color: mainRed,
     ),
     const SizedBox(width: 5),
     Expanded(
        child: Text(
          'Dropping: ${bus.dropping}',
        ),
     ),
   ],
),

const SizedBox(height: 15),

Row(
  children: [
     Icon(
        Icons.event_seat,
        color: seats <= 3
            ? mainRed
            : Colors.green,
     ),

       const SizedBox(width: 7),

       Text(
         '$seats seats available',
         style: TextStyle(

              color: seats <= 3
                  ? mainRed
                  : Colors.green,
              fontWeight:
              FontWeight.bold,
            ),
       ),
     ],
),

const SizedBox(height: 15),

SizedBox(
   width: double.infinity,
   child: ElevatedButton(
     onPressed: seats == 0
          ? null
          : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                 SeatPage(
                    bus: bus,
                    date: date,
                 ),
          ),
        );
     },
     style: ElevatedButton.styleFrom(
        backgroundColor: mainRed,
        foregroundColor:
        Colors.white,
        padding:
        const EdgeInsets.all(15),
     ),
     child: Text(
        seats == 0
            ? 'FULLY BOOKED'
            : 'SELECT SEAT',
        style: const TextStyle(
          fontWeight:
          FontWeight.bold,
        ),
     ),
   ),
),

                       ],
                  ),
                ),
              );
         },
       ),
     );
 }

 Widget timeColumn(
     String time,
     String place,
     ) {
   return Column(
     children: [
       Text(
          time,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
       ),
       Text(
          place,
          style: const TextStyle(
            color: Colors.grey,
          ),
       ),
     ],
   );
 }
}

// ============================================================
// SEAT PAGE
// ============================================================

class SeatPage extends StatefulWidget {
 final Bus bus;
 final DateTime date;

 const SeatPage({
   super.key,
   required this.bus,
   required this.date,
 });

 @override
 State<SeatPage> createState() => _SeatPageState();
}

class _SeatPageState extends State<SeatPage> {
 int? selectedSeat;

// ----------------------------------------------------------
// BOOKED SEATS
// ----------------------------------------------------------

Set<int> get bookedSeats {
  return bookings
      .where(
        (booking) =>
    booking.busName == widget.bus.name &&
        booking.from == widget.bus.from &&
        booking.to == widget.bus.to &&
        booking.date ==
            formatDate(widget.date) &&
        booking.status == 'CONFIRMED',
  )
      .map((booking) => booking.seat)
      .toSet();
}

// ----------------------------------------------------------
// CONTINUE
// ----------------------------------------------------------

void continueBooking() {
  if (selectedSeat == null) {
    showMessage(
      context,
      'Please select a seat first',
    );
    return;
  }

   // Re-check seat before moving ahead.
   if (bookedSeats.contains(selectedSeat)) {
     showMessage(
       context,
       'This seat is already booked',
     );
     return;
   }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PassengerPage(
           bus: widget.bus,
           date: widget.date,
           seat: selectedSeat!,
        ),
      ),
    );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
         'Select Your Seat',
         style: TextStyle(
           fontWeight: FontWeight.bold,
         ),
      ),
      backgroundColor: mainRed,
      foregroundColor: Colors.white,
    ),

     body: SingleChildScrollView(
       padding: const EdgeInsets.all(18),
       child: Column(
         children: [
           Text(
             widget.bus.name,
             style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
             ),
           ),

           Text(
             '${widget.bus.from} → ${widget.bus.to}',
             style: const TextStyle(
                color: Colors.grey,
             ),
           ),

           const SizedBox(height: 18),

// LEGEND
Row(
  mainAxisAlignment:
  MainAxisAlignment.center,
  children: [
     legendBox(
       Colors.green,
       'Available',
     ),
     const SizedBox(width: 10),
     legendBox(
       Colors.blue,
       'Selected',
     ),
     const SizedBox(width: 10),
     legendBox(
       mainRed,
       'Booked',
     ),
  ],
),

const SizedBox(height: 22),

// BUS
Container(
  padding: const EdgeInsets.all(15),
  decoration: BoxDecoration(
     color: Colors.white,
     borderRadius:
     BorderRadius.circular(20),
     border: Border.all(
       color: Colors.grey.shade300,
     ),
  ),
  child: Column(
     children: [
       const Align(
          alignment:
          Alignment.centerRight,
          child: Icon(
            Icons.directions_bus,
            size: 35,
          ),
       ),

const SizedBox(height: 15),

GridView.builder(
  shrinkWrap: true,
  physics:
  const NeverScrollableScrollPhysics(),
  itemCount: widget.bus.capacity,
  gridDelegate:
  const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 4,
    crossAxisSpacing: 10,
    mainAxisSpacing: 12,
  ),
  itemBuilder:
      (context, index) {
    int seat = index + 1;

   bool booked =
   bookedSeats.contains(
      seat,
   );

   bool selected =
       selectedSeat == seat;

   Color seatColor;

   if (booked) {
     seatColor = mainRed;
   } else if (selected) {
     seatColor = Colors.blue;
   } else {
     seatColor = Colors.green;
   }

   return InkWell(
     onTap: booked
         ? null
         : () {
       setState(() {
         selectedSeat =
             seat;
       });
     },
     child: Container(
       decoration:
       BoxDecoration(

                         color: seatColor,
                         borderRadius:
                         BorderRadius.circular(
                            12,
                         ),
                       ),
                       child: Center(
                         child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment
                                 .center,
                            children: [
                              const Icon(
                                 Icons.event_seat,
                                 color:
                                 Colors.white,
                                 size: 22,
                              ),
                              Text(
                                 '$seat',
                                 style:
                                 const TextStyle(
                                   color:
                                   Colors.white,
                                   fontWeight:
                                   FontWeight
                                        .bold,
                                 ),
                              ),
                            ],
                         ),
                       ),
                     ),
                );
              },
         ),
       ],
  ),
),

const SizedBox(height: 22),

// ------------------------------------------------
// THIS IS THE IMPORTANT FIX
// ------------------------------------------------
//
// Berth is displayed ONLY after seat selection.

//

if (selectedSeat != null)
  Container(
    width: double.infinity,
    padding:
    const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: lightRed,
      borderRadius:
      BorderRadius.circular(15),
    ),
    child: Column(
      children: [
        Text(
          'Selected Seat: $selectedSeat',
          style: const TextStyle(
             fontSize: 19,
             fontWeight:
             FontWeight.bold,
          ),
        ),

             const SizedBox(height: 7),

             Text(
               'Berth: ${getBerth(
                  selectedSeat!,
                  widget.bus.capacity,
               )}',
               style: const TextStyle(
                  fontSize: 17,
                  fontWeight:
                  FontWeight.w600,
                  color: mainRed,
               ),
             ),
        ],
      ),
 ),

const SizedBox(height: 20),

SizedBox(
  width: double.infinity,
  height: 55,
  child: ElevatedButton(

                       onPressed: continueBooking,
                       style: ElevatedButton.styleFrom(
                         backgroundColor: mainRed,
                         foregroundColor: Colors.white,
                         shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(15),
                         ),
                       ),
                       child: const Text(
                         'CONTINUE',
                         style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                         ),
                       ),
                  ),
                ),
              ],
         ),
       ),
     );
 }

 Widget legendBox(
     Color color,
     String text,
     ) {
   return Row(
     children: [
       Container(
          height: 14,
          width: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius:
            BorderRadius.circular(4),
          ),
       ),
       const SizedBox(width: 5),
       Text(text),
     ],
   );
 }
}

// ============================================================

// PASSENGER PAGE
// ============================================================

class PassengerPage extends StatefulWidget {
 final Bus bus;
 final DateTime date;
 final int seat;

const PassengerPage({
  super.key,
  required this.bus,
  required this.date,
  required this.seat,
});

 @override
 State<PassengerPage> createState() =>
     _PassengerPageState();
}

class _PassengerPageState
   extends State<PassengerPage> {
 final TextEditingController nameController =
 TextEditingController();

final TextEditingController ageController =
TextEditingController();

final TextEditingController mobileController =
TextEditingController();

void continueToPayment() {
  String name =
  nameController.text.trim();

   String age =
   ageController.text.trim();

   String mobile =
   mobileController.text.trim();

   if (name.isEmpty) {
     showMessage(
       context,
       'Please enter passenger name',
     );
     return;

    }

    if (age.isEmpty) {
      showMessage(
        context,
        'Please enter age',
      );
      return;
    }

    int? ageNumber = int.tryParse(age);

    if (ageNumber == null ||
        ageNumber < 1 ||
        ageNumber > 100) {
      showMessage(
        context,
        'Please enter valid age',
      );
      return;
    }

    if (mobile.length != 10) {
      showMessage(
        context,
        'Please enter valid 10-digit mobile number',
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentPage(
           bus: widget.bus,
           date: widget.date,
           seat: widget.seat,
           passengerName: name,
           age: ageNumber,
           mobile: mobile,
        ),
      ),
    );
}

@override
Widget build(BuildContext context) {

// Berth is calculated from selected seat.
String berth = getBerth(
  widget.seat,
  widget.bus.capacity,
);

return Scaffold(
  appBar: AppBar(
    title: const Text(
       'Passenger Details',
       style: TextStyle(
         fontWeight: FontWeight.bold,
       ),
    ),
    backgroundColor: mainRed,
    foregroundColor: Colors.white,
  ),

  body: SingleChildScrollView(
    padding: const EdgeInsets.all(18),
    child: Column(
      children: [
        const Icon(
          Icons.person,
          size: 75,
          color: mainRed,
        ),

        const SizedBox(height: 8),

        const Text(
          'Enter Passenger Details',
          style: TextStyle(
             fontSize: 23,
             fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 25),

        TextField(
          controller: nameController,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.person,
            ),
            labelText: 'Passenger Name',

       border: OutlineInputBorder(
         borderRadius:
         BorderRadius.circular(15),
       ),
  ),
),

const SizedBox(height: 15),

TextField(
  controller: ageController,
  keyboardType:
  TextInputType.number,
  decoration: InputDecoration(
     prefixIcon: const Icon(
       Icons.cake,
     ),
     labelText: 'Age',
     border: OutlineInputBorder(
       borderRadius:
       BorderRadius.circular(15),
     ),
  ),
),

const SizedBox(height: 15),

TextField(
  controller: mobileController,
  keyboardType:
  TextInputType.phone,
  maxLength: 10,
  decoration: InputDecoration(
     counterText: '',
     prefixIcon: const Icon(
       Icons.phone,
     ),
     labelText: 'Mobile Number',
     border: OutlineInputBorder(
       borderRadius:
       BorderRadius.circular(15),
     ),
  ),
),

const SizedBox(height: 20),

// ------------------------------------------------
// AUTO BERTH
// ------------------------------------------------

Container(
  width: double.infinity,
  padding: const EdgeInsets.all(17),
  decoration: BoxDecoration(
     color: lightRed,
     borderRadius:
     BorderRadius.circular(15),
  ),
  child: Column(
     children: [
       const Text(
          'Seat Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight:
            FontWeight.bold,
          ),
       ),

      const SizedBox(height: 10),

      Text(
         'Seat ${widget.seat}',
         style: const TextStyle(
           fontSize: 17,
         ),
      ),

      const SizedBox(height: 5),

      Text(
         'Berth: $berth',
         style: const TextStyle(
           fontSize: 17,
           fontWeight:
           FontWeight.bold,
           color: mainRed,
         ),
      ),

      const SizedBox(height: 5),

      Text(

                              '${widget.bus.from} → ${widget.bus.to}',
                         ),

                         const SizedBox(height: 5),

                         Text(
                            'Fare: ₹${widget.bus.price}',
                            style: const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                            ),
                         ),
                       ],
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                     onPressed: continueToPayment,
                     style: ElevatedButton.styleFrom(
                       backgroundColor: mainRed,
                       foregroundColor: Colors.white,
                       shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                       ),
                     ),
                     child: const Text(
                       'CONTINUE TO PAYMENT',
                       style: TextStyle(
                          fontWeight: FontWeight.bold,
                       ),
                     ),
                  ),
                ),
              ],
         ),
       ),
     );
 }
}

// ============================================================

// PAYMENT PAGE
// ============================================================

class PaymentPage extends StatefulWidget {
 final Bus bus;
 final DateTime date;
 final int seat;
 final String passengerName;
 final int age;
 final String mobile;

 const PaymentPage({
   super.key,
   required this.bus,
   required this.date,
   required this.seat,
   required this.passengerName,
   required this.age,
   required this.mobile,
 });

 @override
 State<PaymentPage> createState() =>
     _PaymentPageState();
}

class _PaymentPageState
   extends State<PaymentPage> {
 String selectedPayment = 'UPI';

 // ----------------------------------------------------------
 // PAYMENT OPTION
 // ----------------------------------------------------------

 Widget paymentOption(
     String title,
     IconData icon,
     ) {
   bool selected =
       selectedPayment == title;

   return InkWell(
     onTap: () {
       setState(() {
         selectedPayment = title;
       });
     },

child: Container(
  width: double.infinity,
  margin: const EdgeInsets.only(
     bottom: 12,
  ),
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
     color: selected
         ? lightRed
         : Colors.white,
     borderRadius:
     BorderRadius.circular(15),
     border: Border.all(
       color: selected
           ? mainRed
           : Colors.grey.shade300,
       width: selected ? 2 : 1,
     ),
  ),
  child: Row(
     children: [
       Icon(
         icon,
         color: selected
             ? mainRed
             : Colors.grey,
       ),

     const SizedBox(width: 12),

     Expanded(
       child: Text(
          title,
          style: TextStyle(
            fontWeight: selected
                 ? FontWeight.bold
                 : FontWeight.normal,
          ),
       ),
     ),

     Icon(
       selected
           ? Icons.check_circle
           : Icons.circle_outlined,
       color: selected
           ? mainRed

                    : Colors.grey,
               ),
             ],
        ),
      ),
    );
}

// ----------------------------------------------------------
// PAY NOW
// ----------------------------------------------------------

void payNow() {
  String dateText =
  formatDate(widget.date);

    // Re-check seat before booking.
    bool alreadyBooked = bookings.any(
          (booking) =>
      booking.busName ==
          widget.bus.name &&
          booking.from == widget.bus.from &&
          booking.to == widget.bus.to &&
          booking.date == dateText &&
          booking.seat == widget.seat &&
          booking.status == 'CONFIRMED',
    );

    if (alreadyBooked) {
      showMessage(
        context,
        'Sorry! This seat has already been booked.',
      );

        Navigator.pop(context);
        return;
    }

    // Calculate berth from seat.
    String berth = getBerth(
      widget.seat,
      widget.bus.capacity,
    );

    // --------------------------------------------------------
    // CREATE BOOKING
    // --------------------------------------------------------

    Booking newBooking = Booking(
      pnr: generatePNR(),
      passengerName:
      widget.passengerName,
      mobile: widget.mobile,
      busName: widget.bus.name,
      from: widget.bus.from,
      to: widget.bus.to,
      date: dateText,
      departure:
      widget.bus.departure,
      arrival: widget.bus.arrival,
      seat: widget.seat,
      berth: berth,
      busType: widget.bus.type,
      boarding:
      widget.bus.boarding,
      dropping:
      widget.bus.dropping,
      fare: widget.bus.price,
      paymentMethod:
      selectedPayment,
      status: 'CONFIRMED',
    );

    bookings.add(newBooking);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => TicketPage(
           booking: newBooking,
        ),
      ),
           (route) => false,
    );
}

@override
Widget build(BuildContext context) {
  String berth = getBerth(
    widget.seat,
    widget.bus.capacity,
  );

    return Scaffold(

appBar: AppBar(
  title: const Text(
     'Payment',
     style: TextStyle(
       fontWeight: FontWeight.bold,
     ),
  ),
  backgroundColor: mainRed,
  foregroundColor: Colors.white,
),

body: SingleChildScrollView(
  padding: const EdgeInsets.all(18),
  child: Column(
    children: [
      const Icon(
        Icons.payment,
        size: 70,
        color: mainRed,
      ),

      const SizedBox(height: 10),

      const Text(
        'Choose Payment Method',
        style: TextStyle(
           fontSize: 24,
           fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 25),

      // PAYMENT OPTIONS

      paymentOption(
        'UPI',
        Icons.account_balance_wallet,
      ),

      paymentOption(
        'Card',
        Icons.credit_card,
      ),

      paymentOption(
        'Cash',

  Icons.money,
),

const SizedBox(height: 20),

// SUMMARY

Container(
  width: double.infinity,
  padding: const EdgeInsets.all(18),
  decoration: BoxDecoration(
     color: Colors.white,
     borderRadius:
     BorderRadius.circular(18),
     border: Border.all(
       color: Colors.grey.shade300,
     ),
  ),
  child: Column(
     children: [
       const Text(
          'Booking Summary',
          style: TextStyle(
            fontSize: 20,
            fontWeight:
            FontWeight.bold,
          ),
       ),

      const Divider(),

      summaryRow(
         'Passenger',
         widget.passengerName,
      ),

      summaryRow(
         'Route',
         '${widget.bus.from} → ${widget.bus.to}',
      ),

      summaryRow(
         'Bus',
         widget.bus.name,
      ),

      summaryRow(

              'Date',
              formatDate(widget.date),
         ),

         summaryRow(
            'Seat',
            '${widget.seat}',
         ),

         summaryRow(
            'Berth',
            berth,
         ),

         summaryRow(
            'Payment',
            selectedPayment,
         ),

         const Divider(),

         summaryRow(
            'Total Fare',
            '₹${widget.bus.price}',
            bold: true,
         ),
       ],
  ),
),

const SizedBox(height: 25),

SizedBox(
  width: double.infinity,
  height: 55,
  child: ElevatedButton(
    onPressed: payNow,
    style: ElevatedButton.styleFrom(
      backgroundColor: mainRed,
      foregroundColor:
      Colors.white,
      shape:
      RoundedRectangleBorder(
         borderRadius:
         BorderRadius.circular(15),
      ),
    ),

                       child: Text(
                         'PAY ₹${widget.bus.price}',
                         style: const TextStyle(
                            fontSize: 17,
                            fontWeight:
                            FontWeight.bold,
                         ),
                       ),
                  ),
                ),
              ],
         ),
       ),
     );
 }

 Widget summaryRow(
     String title,
     String value, {
       bool bold = false,
     }) {
   return Padding(
     padding:
     const EdgeInsets.symmetric(
       vertical: 7,
     ),
     child: Row(
       children: [
          Expanded(
            child: Text(title),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold
                  ? FontWeight.bold
                  : FontWeight.w600,
            ),
          ),
       ],
     ),
   );
 }
}

// ============================================================
// TICKET PAGE

// ============================================================

class TicketPage extends StatelessWidget {
 final Booking booking;

 const TicketPage({
   super.key,
   required this.booking,
 });

 void showPrintDialog(BuildContext context) {
   showDialog(
     context: context,
     builder: (context) {
       return AlertDialog(
          title: const Text(
            'Print Ticket',
          ),
          content: const Text(
            'Ticket is ready for printing.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                 Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
       );
     },
   );
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text(
          'Booking Confirmed',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
       ),
       backgroundColor: mainRed,
       foregroundColor: Colors.white,
       automaticallyImplyLeading: false,

),

body: SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    children: [
      // SUCCESS
      const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 75,
      ),

     const SizedBox(height: 8),

     const Text(
       'Booking Confirmed!',
       style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
       ),
     ),

     const SizedBox(height: 20),

     // ------------------------------------------------
     // TICKET
     // ------------------------------------------------

     Container(
       width: double.infinity,
       decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
       ),
       child: Column(
          children: [
            // TICKET HEADER

           Container(
             padding:
             const EdgeInsets.all(18),
             decoration: const BoxDecoration(

       color: mainRed,
       borderRadius:
       BorderRadius.only(
          topLeft:
          Radius.circular(20),
          topRight:
          Radius.circular(20),
       ),
     ),
     child: Row(
       children: [
          const Icon(
            Icons.directions_bus,
            color: Colors.white,
            size: 35,
          ),

            const SizedBox(width: 10),

            const Expanded(
              child: Text(
                'BusGo E-Ticket',
                style: TextStyle(
                   color:
                   Colors.white,
                   fontSize: 21,
                   fontWeight:
                   FontWeight.bold,
                ),
              ),
            ),

            Text(
              booking.status,
              style:
              const TextStyle(
                color:
                Colors.white,
                fontWeight:
                FontWeight.bold,
              ),
            ),
       ],
     ),
),

Padding(

padding:
const EdgeInsets.all(18),
child: Column(
  children: [
    Text(
      '${booking.from} → ${booking.to}',
      style:
      const TextStyle(
        fontSize: 23,
        fontWeight:
        FontWeight.bold,
      ),
    ),

    const SizedBox(height: 6),

    Text(
      booking.busName,
      style:
      const TextStyle(
        color: Colors.grey,
        fontSize: 16,
      ),
    ),

    const Divider(
      height: 30,
    ),

    ticketRow(
      'PNR',
      booking.pnr,
    ),

    ticketRow(
      'Passenger',
      booking.passengerName,
    ),

    ticketRow(
      'Mobile',
      booking.mobile,
    ),

    ticketRow(
      'Date',
      booking.date,

),

ticketRow(
  'Departure',
  booking.departure,
),

ticketRow(
  'Arrival',
  booking.arrival,
),

ticketRow(
  'Seat',
  '${booking.seat}',
),

ticketRow(
  'Berth',
  booking.berth,
),

ticketRow(
  'Boarding',
  booking.boarding,
),

ticketRow(
  'Dropping',
  booking.dropping,
),

ticketRow(
  'Payment',
  booking.paymentMethod,
),

const Divider(
  height: 30,
),

Row(
  mainAxisAlignment:
  MainAxisAlignment
      .spaceBetween,
  children: [
    const Text(

                  'TOTAL FARE',
                  style:
                  TextStyle(
                    fontWeight:
                    FontWeight
                         .bold,
                    fontSize: 17,
                  ),
                ),
                Text(
                   '₹${booking.fare}',
                   style:
                   const TextStyle(
                     color: mainRed,
                     fontSize: 22,
                     fontWeight:
                     FontWeight
                          .bold,
                   ),
                ),
              ],
            ),
       ],
     ),
),

Container(
  width: double.infinity,
  padding:
  const EdgeInsets.all(15),
  decoration:
  const BoxDecoration(
    color: lightRed,
    borderRadius:
    BorderRadius.only(
       bottomLeft:
       Radius.circular(20),
       bottomRight:
       Radius.circular(20),
    ),
  ),

                                                       🚌',
  child: const Text(
    'Thank you for booking with BusGo! Happy Journey
    textAlign:
    TextAlign.center,
    style: TextStyle(
       fontWeight:

                     FontWeight.bold,
                ),
              ),
         ),
       ],
  ),
),

const SizedBox(height: 20),

// PRINT

SizedBox(
  width: double.infinity,
  height: 52,
  child: OutlinedButton.icon(
     onPressed: () {
       showPrintDialog(context);
     },
     icon: const Icon(
       Icons.print,
     ),
     label: const Text(
       'PRINT TICKET',
       style: TextStyle(
          fontWeight:
          FontWeight.bold,
       ),
     ),
  ),
),

const SizedBox(height: 12),

// MY BOOKINGS

SizedBox(
  width: double.infinity,
  height: 52,
  child: ElevatedButton(
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const MyBookingsPage(),
        ),

                        );
                      },
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor: mainRed,
                        foregroundColor:
                        Colors.white,
                      ),
                      child: const Text(
                        'MY BOOKINGS',
                        style: TextStyle(
                           fontWeight:
                           FontWeight.bold,
                        ),
                      ),
                 ),
               ),

               const SizedBox(height: 12),

               // HOME

               TextButton(
                 onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                         builder: (_) =>
                             HomePage(username: registeredName ?? 'User'),
                      ),
                           (route) => false,
                    );
                 },
                 child: const Text(
                    'BACK TO HOME',
                 ),
               ),
             ],
        ),
      ),
    );
}

Widget ticketRow(
    String title,
    String value,
    ) {

     return Padding(
       padding:
       const EdgeInsets.symmetric(
         vertical: 6,
       ),
       child: Row(
         crossAxisAlignment:
         CrossAxisAlignment.start,
         children: [
            SizedBox(
              width: 105,
              child: Text(
                title,
                style: const TextStyle(
                   color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign:
                TextAlign.right,
                style: const TextStyle(
                   fontWeight:
                   FontWeight.w600,
                ),
              ),
            ),
         ],
       ),
     );
 }
}

// ============================================================
// MY BOOKINGS PAGE
// ============================================================

class MyBookingsPage extends StatefulWidget {
 const MyBookingsPage({super.key});

 @override
 State<MyBookingsPage> createState() =>
     _MyBookingsPageState();
}

class _MyBookingsPageState
   extends State<MyBookingsPage> {
 final TextEditingController searchController =
 TextEditingController();

 String searchText = '';

 List<Booking> get filteredBookings {
   if (searchText.isEmpty) {
     return bookings;
   }

     return bookings.where((booking) {
       String search =
       searchText.toLowerCase();

       return booking.pnr
           .toLowerCase()
           .contains(search) ||
           booking.mobile
               .toLowerCase()
               .contains(search) ||
           booking.passengerName
               .toLowerCase()
               .contains(search);
     }).toList();
 }

 // ----------------------------------------------------------
 // CANCEL BOOKING
 // ----------------------------------------------------------

 void cancelBooking(Booking booking) {
   if (booking.status == 'CANCELLED') {
     return;
   }

     showDialog(
       context: context,
       builder: (dialogContext) {
         return AlertDialog(
           title: const Text(
             'Cancel Ticket?',
           ),
           content: Text(
             'Do you want to cancel ticket ${booking.pnr}?',
           ),

             actions: [
               TextButton(
                 onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                 },
                 child: const Text(
                    'NO',
                 ),
               ),

               ElevatedButton(
                 onPressed: () {
                   setState(() {
                     booking.status =
                     'CANCELLED';
                   });

                   Navigator.pop(
                     dialogContext,
                   );

                   showMessage(
                     context,
                     'Ticket cancelled successfully',
                   );
                 },
                 style:
                 ElevatedButton.styleFrom(
                    backgroundColor: mainRed,
                    foregroundColor:
                    Colors.white,
                 ),
                 child: const Text(
                    'YES, CANCEL',
                 ),
               ),
             ],
        );
      },
    );
}

// ----------------------------------------------------------
// OPEN TICKET
// ----------------------------------------------------------

void openTicket(Booking booking) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => TicketPage(
         booking: booking,
      ),
    ),
  );
}

@override
Widget build(BuildContext context) {
  List<Booking> list =
      filteredBookings;

  return Scaffold(
    appBar: AppBar(
      title: const Text(
         'My Bookings',
         style: TextStyle(
           fontWeight: FontWeight.bold,
         ),
      ),
      backgroundColor: mainRed,
      foregroundColor: Colors.white,
    ),

    body: Column(
      children: [
        // SEARCH
        Padding(
          padding: const EdgeInsets.all(15),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
               setState(() {
                 searchText =
                     value.trim();
               });
            },
            decoration: InputDecoration(
               prefixIcon: const Icon(
                 Icons.search,
               ),
               suffixIcon: searchText

               .isNotEmpty
               ? IconButton(
             onPressed: () {
               searchController
                   .clear();

               setState(() {
                 searchText = '';
               });
             },
             icon: const Icon(
                Icons.clear,
             ),
         )
              : null,
         hintText:
         'Search PNR, name or mobile',
         border: OutlineInputBorder(
           borderRadius:
           BorderRadius.circular(
              15,
           ),
         ),
    ),
  ),
),

Expanded(
  child: list.isEmpty
       ? const Center(
    child: Text(
       'No bookings found',
       style: TextStyle(
         fontSize: 18,
         color: Colors.grey,
       ),
    ),
  )
       : ListView.builder(
    padding:
    const EdgeInsets
         .symmetric(
       horizontal: 15,
    ),
    itemCount:
    list.length,
    itemBuilder:

  (context, index) {
Booking booking =
list[index];

bool cancelled =
    booking.status ==
        'CANCELLED';

return Card(
  margin:
  const EdgeInsets
       .only(
     bottom: 15,
  ),
  child: Padding(
     padding:
     const EdgeInsets
         .all(15),
     child: Column(
       children: [
         Row(
           children: [
             Container(
               padding:
               const EdgeInsets
                    .all(
                 10,
               ),
               decoration:
               BoxDecoration(
                 color:
                 cancelled
                      ? Colors
                      .grey
                      .shade200
                      : lightRed,
                 borderRadius:
                 BorderRadius
                      .circular(
                    12,
                 ),
               ),
               child:
               Icon(
                 Icons
                      .confirmation_number,
                 color:

       cancelled
           ? Colors
           .grey
           : mainRed,
     ),
),

const SizedBox(
   width: 12,
),

Expanded(
  child:
  Column(
    crossAxisAlignment:
    CrossAxisAlignment
         .start,
    children: [
      Text(
         booking
              .busName,
         style:
         const TextStyle(
            fontWeight:
            FontWeight
                .bold,
            fontSize:
            17,
         ),
      ),

            Text(
              '${booking.from} → ${booking.to}',
            ),

            Text(
              'PNR: ${booking.pnr}',
              style:
              const TextStyle(
                 color:
                 Colors.grey,
              ),
            ),
       ],
     ),
),

    Container(
       padding:
       const EdgeInsets
            .symmetric(
         horizontal:
         9,
         vertical:
         6,
       ),
       decoration:
       BoxDecoration(
         color:
         cancelled
              ? Colors
              .grey
              .shade300
              : Colors
              .green
              .shade100,
         borderRadius:
         BorderRadius
              .circular(
            10,
         ),
       ),
       child: Text(
         booking
              .status,
         style:
         TextStyle(
            color:
            cancelled
                ? Colors
                .grey
                : Colors
                .green
                .shade800,
            fontWeight:
            FontWeight
                .bold,
            fontSize:
            11,
         ),
       ),
    ),
  ],
),

const Divider(
  height: 25,
),

Row(
  children: [
    Expanded(
       child:
       infoItem(
         Icons
              .calendar_month,
         booking
              .date,
       ),
    ),
    Expanded(
       child:
       infoItem(
         Icons
              .event_seat,
         'Seat ${booking.seat}',
       ),
    ),
  ],
),

const SizedBox(
  height: 10,
),

Row(
  children: [
    Expanded(
       child:
       infoItem(
         Icons
              .layers,
         booking
              .berth,
       ),
    ),
    Expanded(
       child:
       infoItem(
         Icons
              .currency_rupee,

           '₹${booking.fare}',
         ),
    ),
  ],
),

const SizedBox(
  height: 15,
),

Row(
  children: [
    Expanded(
       child:
       OutlinedButton(
         onPressed:
              () {
            openTicket(
                booking);
         },
         child:
         const Text(
            'VIEW TICKET',
         ),
       ),
    ),

    const SizedBox(
       width: 10,
    ),

    Expanded(
      child:
      ElevatedButton(
        onPressed:
        cancelled
             ? null
             : () {
           cancelBooking(
             booking,
           );
        },
        style:
        ElevatedButton
             .styleFrom(
           backgroundColor:
           mainRed,

                                                  foregroundColor:
                                                  Colors
                                                      .white,
                                                ),
                                                child:
                                                const Text(
                                                   'CANCEL',
                                                ),
                                              ),
                                         ),
                                       ],
                                     ),
                                ],
                              ),
                         ),
                       );
                  },
                ),
              ),
         ],
       ),
     );
 }

 Widget infoItem(
     IconData icon,
     String text,
     ) {
   return Row(
     children: [
       Icon(
          icon,
          size: 19,
          color: mainRed,
       ),
       const SizedBox(width: 6),
       Expanded(
          child: Text(
            text,
            overflow:
            TextOverflow.ellipsis,
          ),
       ),
     ],
   );
 }
}


