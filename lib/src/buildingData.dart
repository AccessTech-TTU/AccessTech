import 'building_screen.dart';

List<BuildingInfo> favoriteBuildings = [
  // buildingData[1],
  // buildingData[10],
  // buildingData[18],
];
// List<BuildingInfo> popularBuildings = [
//   buildingData[1],
//   buildingData[10],
//   buildingData[18],
// ];
List<BuildingInfo> popularBuildings = buildingData.sublist(0, 10);

final List<BuildingInfo> buildingData = [
  BuildingInfo(
    name: 'Human Sciences Building',
    description: "The College of Human Sciences features programs ranging from family studies to financial planning to fashion design to the study of addiction of recovery.",
    imageUrl: 'assets/sub.jpg',
    hours: "8am 12pm",
    address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Administration Building',
    description: "The Administration Building, with its distinctive bell towers, was the first structure built on the campus. The facility houses administrative offices for the university and for the Texas Tech University System.",
    imageUrl: 'assets/sub.jpg',
    hours: "8am 12pm",
    address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Industrial, Manufacturing, and Systems Engineering Bldg',
    description: "The building is home to the Department of Industrial, Manufacturing & Systems Engineering classrooms, labs and offices.",
    imageUrl: 'assets/sub.jpg',
    hours: "8am 12pm",
    address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
   ),
  BuildingInfo(
    name: 'Electrical and Computer Engineering Bldg',
    description: "The building is home to the Department of Electrical and Computer Engineering classrooms, research labs and administrative offices.",
    imageUrl: 'assets/sub.jpg',
    hours: "8am 12pm",
    address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Chemistry Building',
    description: "The building is home to the Department of Chemistry and Biochemistry classrooms, research labs and administrative offices.",
    imageUrl: 'assets/sub.jpg',
    hours: "8am 12pm",
    address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Math Building',
    description: "The building houses Department of Mathematics and Statistics classrooms, labs and offices.",
    imageUrl: 'assets/sub.jpg',
    hours: "8am 12pm",
    address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Agricultural Science Building',
    description: "The building is home to offices and classrooms for the College of Agricultural Sciences and Natural Resources.",
    imageUrl: 'assets/sub.jpg',
    hours: "8am 12pm",
    address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Science - Physics and Geosciences',
    description: "The building is home to the Departments of Geoscience and Physics classrooms, labs and offices.",
    imageUrl: 'assets/sub.jpg',
    hours: "8am 12pm",
    address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Civil Engineering Building',
    description: "The building houses the Department of Civil Engineering classrooms, research labs and administrative offices.",
    imageUrl: 'assets/sub.jpg',
    hours: "8am 12pm",
    address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Student Union Building',
    description: "The Student Union Building houses a food court, Barnes & Noble Bookstore, Starbucks, the Allen Theatre, Student Government Association and work space for many of the more than 400 student organizations.",
    imageUrl: 'assets/sub.jpg',
    hours: "8am 12pm",
    address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Music Building',
    description: "The facility houses School of Music classroom, performance and practice halls and offices.",
    imageUrl: 'assets/sub.jpg',
    hours: "8am 12pm",
    address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Holden Hall Building',
    description: "Holden Hall houses the College of Arts and Sciences administrative offices and classrooms. The original building features a 1,300 square-foot fresco mural by renowned painter Peter Hurd.",
    imageUrl: 'assets/sub.jpg',
    hours: "8am 12pm",
    address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'National Wind Institute',
    description: "The National Wind Institute represents the nation's leading university wind-focused research and education enterprise.",
    imageUrl: 'assets/sub.jpg',
    hours: "8am 12pm",
    address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Terry Fuller Petroleum Engineering Building',
    description: "The Terry Fuller Petroleum Engineering Research Building has approximately 42,000 square feet of modern classroom and research space and features a unique cluster of laboratories.",
    imageUrl: 'assets/sub.jpg',
    hours: "8am 12pm",
    address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Development Office Building',
    description: "The building is home to the Office of Institutional Advancement which oversees fundraising for the Texas Tech University System.",
    imageUrl: 'assets/sub.jpg',
    hours: "8am 12pm",
    address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Agricultural Pavilion Building',
    description: "The building is home to offices, labs and classrooms for the Departments of Landscape Architecture and Range & Wildlife Management.",
    imageUrl: 'assets/sub.jpg',
    hours: "8am 12pm",
    address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'McClellan Hall Building',
    description: "The building is the home of the Honors College administrative offices.",
    imageUrl: 'assets/sub.jpg',
      hours: "8am 12pm",
      address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'McKenzie-Merket Alumni Center Building',
    description: 'The facility houses the administrative office of the Texas Tech Alumni Association as well as a variety of meeting and event venues.',
    imageUrl: 'assets/sub.jpg',
      hours: "8am 12pm",
      address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Doak Hall Building',
    description: "The building houses various business offices of Texas Tech University.",
    imageUrl: 'assets/sub.jpg',
      hours: "8am 12pm",
      address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Drane Hall Building',
    description: "Drane Hall houses various business offices of Texas Tech University as well as administrative offices of the College of Visual and Performing Arts.",
    imageUrl: 'assets/sub.jpg',
      hours: "8am 12pm",
      address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Horn Hall Building',
    description: "Horn Hall is an all-female, movable furniture residence hall. It is located on the southeast side of campus close to the Student Union building and the Music building. Formal and informal lounges offer opportunities for gatherings. Also available in each hall are study rooms, a TV lounge and vending machines. Limitless laundry lounges are available for all residents.",
    imageUrl: 'assets/sub.jpg',
      hours: "8am 12pm",
      address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Knapp Hall Building',
    description: "Knapp Hall is an all-female, movable furniture residence hall. The Women in Science and Engineering (WISE) Learning Community is located in Knapp Hall on the southeast side of campus, close to the Student Union building and the Music building. Formal and informal lounges offer opportunities for gatherings. Also available in each hall are study rooms, a TV lounge and vending machines. Limitless laundry lounges are available for all residents.",
    imageUrl: 'assets/sub.jpg',
      hours: "8am 12pm",
      address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Human Science Cottage Building',
    description: "East of the Texas Tech College of Human Sciences",
    imageUrl: 'assets/sub.jpg',
      hours: "8am 12pm",
      address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'West Hall Building',
    description: "The Visitor's Center, undergraduate admissions offices, the registrar's office, student business services and the scholarship and financial aid offices are here.",
    imageUrl: 'assets/sub.jpg',
      hours: "8am 12pm",
      address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Sneed Hall Building',
    description: "Sneed Hall is an all-male, movable furniture residence hall. The Men of STEM (Science Technology, Engineering and Mathematics) Learning Community is located in Sneed Hall near the College of Engineering, West Hall and Holden Hall.",
    imageUrl: 'assets/sub.jpg',
      hours: "8am 12pm",
      address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Bledsoe Hall Building',
    description: "Bledsoe Hall is an all-male, movable furniture residence hall. The Engineering Success Learning Community is located in Bledsoe Hall, and residents have the opportunity to interact with students and faculty in the College of Engineering.",
    imageUrl: 'assets/sub.jpg',
      hours: "8am 12pm",
      address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  BuildingInfo(
    name: 'Gordon Hall Building',
    description: "Gordon Hall is a coed, suite-style residence hall located on the northeast side of campus. Students in the hall share a suite with students of the same gender only. A furnished living room sits between two bedroom units. Each fully furnished bedroom unit accommodates one to two students and includes a vanity area and private bathroom.",
    imageUrl: 'assets/sub.jpg',
      hours: "8am 12pm",
      address:  "fdvr",
    accessibleDoors: "Automatic doors at north entrance",
    ramps: "Ramps available at the main entrance",
    elevators: "Elevators to all floors",
    restrooms: "Accessible restrooms on each floor",
  ),
  // BuildingInfo(
  //   name: 'Jones Stadium Building',
  //   description: "Jones AT&T Stadium is a football stadium located in Lubbock, Texas that serves as the home field of the Texas Tech Red Raiders. The stadium was opened in 1947 and has a current seating capacity of 60,454.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Ticket Office Stadium Building',
  //   description: "The Ticket Office is located on the North side of the Sports Performance Center",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'CASNR Annex Building',
  //   description: "The building is home to offices, labs and classrooms for the Departments of Landscape Architecture and Range & Wildlife Management.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Educational TV Station Building',
  //   description: "Bio stuff.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Agriculture Education Communication Building',
  //   description: "The building houses the Department of Agricultural Education and Communications which offers undergraduate and graduate degrees.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Creative Movement Studio',
  //   description: "The Creative Movement Studio is a multi-purpose studio that houses the Dance & Theatre programs, including studio spaces for rehearsals, and the university's cheer and pom squads. It is located at the southwest corner of Akron and Glenna Goodacre Avenues, just north of the Petroleum Engineering building.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Library Building',
  //   description: "The University Library is the state's third largest library with nearly two million books and a myriad of electronic publications and databases.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Engineering Center Building',
  //   description: "The building is home to the offices of the Dean of the Edward E. Whitacre Jr. College of Engineering.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Chemical Engineering Building',
  //   description: 'The building houses the Department Chemical Engineering classrooms, research labs and administrative offices.',
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Bayer Plant Science Building',
  //   description: "The new building has an open lab design with the required support and graduate student spaces, one instructional lab and a departmental office suite.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Fisheries and Wildlife Building',
  //   description: "The building is home to Department of Natural Resources Management classrooms, research labs and offices.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Kinesiology and Sport Management Building',
  //   description: "The building is home to the Kinesiology & Sport Management Department classrooms, research labs and administrative offices.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Wall Hall Building',
  //   description: "A building no one can find.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  //
  // BuildingInfo(
  //   name: 'Psychology Building',
  //   description: "The Visitor's Center, undergraduate admissions offices, the registrar's office, student business services and the scholarship and financial aid offices are here.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Charles E. Maedgen Jr. Theatre Building',
  //   description: "The Charles E. Maedgen Jr. Theatre is home to the Department of Theatre and Dance. The main stage and adjoining lab theatre offer a variety of performances that are open to the public.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Stangel Hall Building',
  //   description: "Stangel Hall is a coed, built-in furniture residence hall. The Health Sciences Learning Community is located in Stangel Hall on the central western edge of the main campus, near Agriculture row, Biology building, and Experimental Science buildings.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Murdough Hall Building',
  //   description: "Murdough Hall is a coed, built-in furniture residence hall. The Media and Communication, First Gen, PreLaw, and the Davis College of Agricultural Sciences and Natural Resources learning communities are located in Murdough Hall on the central western edge of the main campus near Agriculture row, Biology, and Experimental Science buildings.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Hulen Hall Building',
  //   description: "Hulen Hall is a coed, built-in furniture residence hall. The Future Teachers Learning Community is located in Hulen Hall on the south side of campus, near the College of Architecture, English, Philosophy and Education buildings. ",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Clement Hall Building',
  //   description: "Clement Hall is a coed, built-in furniture residence hall. The Architecture and Design Learning Community is located in Clement Hall, near the College of Architecture, English, Philosophy, and Education buildings.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Art 3D Annex Building',
  //   description: "The Art 3-D annex is home to sculpture, jewelry design and metalsmithing classes in the School of Art.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // // // BuildingInfo(
  // // //   name: 'Foreign Language Building',
  // // //   description: "Bio place stuff.",
  // // //   imageUrl: 'assets/sub.jpg',
  // // // ),
  // BuildingInfo(
  //   name: 'Museum Building',
  //   description: "The Museum of Texas Tech features the Diamond M art collection and a range of works in the African, pre-Columbian and Taos/Southwest galleries.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Media and Communication Building',
  //   description: "The Media & Communication building houses the College of Media & Communication, the Department of Communication Studies, Army ROTC, Atmospheric Science, Texas Tech University Press and Student Media.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // // // -----------------------------------------------------------------
  // // // BuildingInfo(
  // // //   name: 'Wind Engineering Research Building',
  // // //   description: 'Academic hub housing classrooms and offices.',
  // // //   imageUrl: 'assets/sub.jpg',
  // // // ),
  // BuildingInfo(
  //   name: 'Chitwood Hall Building',
  //   description: "Chitwood Hall is a co-ed, built-in furniture residence hall. The First Year Success (FYS) Learning Community is located on the southwest side of campus near the College of Architecture and the Law School, and is only available to incoming freshman.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Coleman Hall Building',
  //   description: "Coleman Hall is a coed, built-in furniture residence hall. Men and women live on alternating floors. Features of the hall include a TV lounge, and a computer lab. Limitless laundry lounges are available for all residents.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Weymouth Hall Building',
  //   description: "Weymouth Hall is a co-ed, built-in furniture residence hall. The First Year Success (FYS) Learning Community is located in Weymouth Hall on the southwest side of campus near the College of Architecture and the Law School.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Wiggins Complex Building',
  //   description: "The Wiggins Complex houses University Career Services, Student Housing, and Hospitality Services of Texas Tech University.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Biology Building',
  //   description: "The building is home to the Department of Biological Sciences classrooms, research labs, administrative offices and the Biology Auditorium.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Architecture Building',
  //   description: "The College of Architecture building opened in 1971. Architecture has been offered at Texas Tech since 1927. It became a full college in 1986.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Central Heating and Cooling Plant I Building',
  //   description: "Central Heating and Cooling Plants (CHACP) provide steam and chilled water for heating and cooling, respectively",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Law Building',
  //   description: "The building houses the School of Law classrooms, labs, courtrooms, law library, the Lanier Professional Development Center and offices.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Physical Plant Annex Building',
  //   description: "",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Track, Terry & Linda Fuller',
  //   description: "The Terry and Linda Fuller Track boasts a Mondo surface, considered the top running surface in the world and used in the 2008 Olympic games.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Agricultural Engineering Lab',
  //   description: "",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Greenhouse and Horticultural Building',
  //   description: "The facility houses research projects as well as teaching materials for various plant-related classes.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Goddard Range Wildlife Building',
  //   description: "The building is home to the Office of the Dean of the College of Agricultural Sciences and Natural Resources as well as classrooms and lab space.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Rec Aquatic Facilities Building',
  //   description: "The swimming facility at the Student Recreational Center offers a variety of swim classes and open swimming sessions.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Central Heating and Cooling Plant II Building',
  //   description: "Central Heating and Cooling Plants (CHACP) provide steam and chilled water for heating and cooling, respectively.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Food Tech Building',
  //   description: "The building houses classrooms, labs and offices for the Department of Food Science.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'National Ranching Heritage Center - Devit and Mallet Ranch Building',
  //   description: 'The park and museum is dedicated to the preservation and interpretation of American ranching history.',
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Art Building',
  //   description: "The building is home to the School of Art classrooms, studios labs and administrative offices and the Landmark Arts Gallery.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'TTU Warehouse Building',
  //   description: "The Central Warehouse provides centralized receiving for freight items you need for your department. Let us know that you are shipping items to our address, 604 N. Knoxville Ave. and we will let you know when they arrive.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Meat Lab and Livestock Arena',
  //   description: "The Meat Lab is home to research and teaching facilities. The Livestock arena is used for various animal classes and events.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Student Rec Center Building',
  //   description: "The Robert H. Ewalt Student Recreation Center features a raised jogging track, volleyball/basketball courts and weight room facilities. The climbing, outdoor pursuits and aquatic centers are also found here.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Chemical Storage Building',
  //   description: "",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // // // BuildingInfo(
  // // //   name: 'Reese Wind Science Engineering',
  // // //   description: "Admin stuff.",
  // // //   imageUrl: 'assets/sub.jpg',
  // // // ),
  // BuildingInfo(
  //   name: 'KTTZ-TV, PBS Station',
  //   description: "The facility houses the studios and offices of KTXT-TV, the Texas Tech owned Public Broadcasting Station in Lubbock.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // // // BuildingInfo(
  // // //   name: 'Range & Wildlife Field Annex',
  // // //   description: "Smarter yeehaw people.",
  // // //   imageUrl: 'assets/sub.jpg',
  // // // ),
  // BuildingInfo(
  //   name: 'Entomology Erskine Building',
  //   description: "",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Grantham Building',
  //   description: "",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Fiber and Polymer Building',
  //   description: "Texas Tech University's Fiber and Biopolymer Research Institute (FBRI) is equipped and staffed to conduct research and development activities ranging from small-scale testing through large-scale manufacturing. A fundamental objective is to foster greater use of the natural fibers and increase textile manufacturing in Texas.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Robert Nash Interpretive Center',
  //   description: "",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Lubbock Lake Landmark Building',
  //   description: "The Lubbock Lake Landmark is one of the foremost New World archeological sites, providing proof of consistent human habitation at one North American location for about 12,000 years.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Athletic Train Center Bubble Building',
  //   description: "Known as the Bubble, the facility offers weight rooms, indoor track facilities and practice areas during inclement weather.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Housing Services Building',
  //   description: "The building is home to some of the university's student residence hall administrative offices.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Creative Movement Studio',
  //   description: "The Creative Movement Studio is a multi-purpose studio that houses the Dance & Theatre programs, including studio spaces for rehearsals, and the university's cheer and pom squads.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Mechanical Engineering North (MEN) Building',
  //   description: "The building houses Department of Mechanical Engineering classrooms, research labs and offices.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Mechanical Engineering South (MES) Building',
  //   description: "The building houses Department of Mechanical Engineering classrooms, research labs and offices.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // // // BuildingInfo(
  // // //   name: 'Wind Engineering Research Building',
  // // //   description: "Admin stuff.",
  // // //   imageUrl: 'assets/sub.jpg',
  // // // ),
  // BuildingInfo(
  //   name: 'Lbb Lake Landmark Crew Building',
  //   description: '',
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Skyview Observatory Building',
  //   description: "The Preston Gott Skyview Observatory is not open to the general public except for pre-planned events. If you or your community group are interested in an observatory event, please contact the Texas Tech Department of Physics & Astronomy.  ",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Dan Law Field (Baseball) at Rip Griffin Park',
  //   description: "The Law is home to the Texas Tech Red Raider baseball team and has a seating capacity over 4,000.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'West Locker Rooms DLF',
  //   description: "",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'International Cultural Center Building',
  //   description: "The International Cultural Center houses Texas Tech's Office of International Affairs and Study Abroad programs, as well as a U.S. passport office. The university offers a variety of educational opportunities in more than 70 countries worldwide.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Lbb Lake Landmark Prefab Building',
  //   description: "",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Southwest Collection/Special Collections Library',
  //   description: "The Southwest Collections/Special Collections Library is a historical research center and archive of materials relating to the American Southwest. The Vietnam Collection is housed here.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Athletic Services Building',
  //   description: "",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Admin Support Center Building',
  //   description: "This facility houses Transportation & Parking Services, IT Help Central, and the MailTech postal operation.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'United Supermarket Arena',
  //   description: "The 15,000 seat multi-purpose facility is home to Texas Tech basketball and volleyball. The arena also hosts concerts by some of the biggest names in music.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Carpenter/Wells Complex',
  //   description: "The Carpenter/Wells Complex features 3 and 4 bedroom suite-style residences for men and women of sophomore classification or higher. The complex is open year round for the convenience of residents. Students share a suite with students of the same gender.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Education Building',
  //   description: "The Education building opened in 2002. The building faces the English/Philosophy building across a large courtyard. The two buildings mirror each other in architectural design.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // // BuildingInfo(
  // //   name: 'English Philosophy Building',
  // //   description: "The English/Philosophy building opened in 2002. The building faces the Education building across a large courtyard. The two buildings mirror each other in architectural design.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'TTU Police Dept Building',
  // //   description: "The building is home to the Texas Tech University Police Department.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Animal Food Science Building',
  // //   description: "The building is home to Department of Animal and Food Sciences classrooms, research labs and administrative offices as well as COWamongus, a food service and retail store.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Burkhart Center for Autism Education and Research',
  // //   description: "The Burkhart Center for Autism Education and Research, named for Jim and Jere Lynn Burkhart who have made significant contributions to the establishment and mission of the Center, officially opened in October 2005.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'University Parking Shop',
  // //   description: "",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Experimental Science Building',
  // //   description: "The building houses multi-discipline research laboratories and classrooms.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // //----------------------------------------------------------------
  // // BuildingInfo(
  // //   name: 'Garst Pavilion Building',
  // //   description: '',
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Texas Tech Plaza Building',
  // //   description: "Owned by the university, Texas Tech Plaza houses offices for eLearning & Academic Partnerships and the Skyviews restaurant, operated by the College of Human Sciences.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Flint Garage',
  // //   description: "Visitor information and passes are available.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Baseball Clubhouse',
  // //   description: "",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Rawls Turf Care Center',
  // //   description: "",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Plant & Soil Science Fld Building',
  // //   description: "We are a student-focused and research-intense department, offering a range of multidisciplinary coursework and academic programs.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Football Training Facility Building',
  // //   description: "The Athletic Complex, commonly known as the Football Training Complex or FTC, features training facilities and access to the outdoor football practice field.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Marsha Sharp Center for Student Athletes Building',
  // //   description: "The facility houses offices and facilities dedicated to the academic success of student athletes.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Student Wellness Center Building',
  // //   description: "The Student Wellness Center houses both Student Health Services and the Student Counseling Center. A pharmacy that offers student discounts is located in the building.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Gold Course, Rawls (RGOLF)',
  // //   description: "The Tom Doak designed golf course is the recipient of several national honors as one of the top university-owned courses in the country.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Equestrian Center',
  // //   description: "The 50 acre home of the Texas Tech Equestrian Team, Horse Judging Team, Ranch Horse Team, Rodeo Team and Therapeutic Riding and Therapy Center.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'EQC Stall Barn',
  // //   description: "",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Murray Hall Building',
  // //   description: "Murray Hall offers 3 and 4 bedroom suite-style residences for men and women of any classification. Students share a suite with students of the same gender.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Rawls College of Business Building',
  // //   description: "The new Rawls College of Business is a 140,000 square-foot building state-of the art LEED-certified building.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Lanier Professional Development Center',
  // //   description: "The facility is an addition to the School of Law featuring classrooms, offices and a state-of-the art courtroom.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Center Addiction Recovery Building',
  // //   description: "The facility is part of the College of Human Sciences and houses the offices, classrooms and meeting rooms for the Center for the Study of Addiction and Recovery.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Library Storage Facility',
  // //   description: "The Library's Remote Storage Facility houses over 132,000 items that cannot be housed at the main Library and encompasses over 14,000 square feet in its three buildings. ",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Reese Technology Center',
  // //   description: '',
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Livermore Center Building',
  // //   description: "The Livermore Center is part of the Department of Chemical Engineering and provides space for classrooms and labs.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'TTU Downtown Center Building',
  // //   description: "Office and College Administrative Building",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'EQC Therapeutic Riding Center Building',
  // //   description: " Texas Tech Therapeutic Riding Center is a non-profit 501(c)3 organization.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Rawls Golf Course Clubhouse',
  // //   description: "",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Boston Residence Hall Dinning',
  // //   description: "This project constructs a 178,000 square foot new building for the University Student Housing & Hospitality Services at the corner of 19th Street and Boston Ave. T",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'J.T & Margaret Talkington Hall',
  // //   description: "Talkington Hall offers 2 and 4 bedroom suite-style residences for men and women of any classification. Students share a suite with students of the same gender.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'East Loop Research Building',
  // //   description: "",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'GIS Lab Building',
  // //   description: "The Geographic Information Systems Computer Lab located in Holden Hall Rm 204 is primarily used to teach courses in GIS. The lab is equipped with 16 networked Dell workstations running under Windows 7 Professional. ",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Communication Services Building',
  // //   description: "As part of the Texas Tech University System, Communication Services maintains a Voice over Internet Protocol (VoIP) infrastructure to provide telephone services for Texas Tech entities. Communication Services also hosts one of the leading contact center solutions which currently supports more than 75+ call centers in TTUHSC clinics located in Abilene, Amarillo, El Paso, Midland/Odessa, and Lubbock. In addition Communication Services continues to support the telephone infrastructure, all university-owned cellular voice and data devices.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Inst For Environmental Human Health',
  // //   description: "",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Fredericksburg Building',
  // //   description: "",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Pantex Residence 2 Building',
  // //   description: "",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Pantex Barn',
  // //   description: "",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Reese TIEHH Building',
  // //   description: "",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'Feedmill',
  // //   description: "",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // BuildingInfo(
  // //   name: 'New Deal Research Center',
  // //   description: "The Texas Tech University New Deal Research Farm has approximately 120 acres that support the crop production research for the university's Department of Plant and Soil Science.",
  // //   imageUrl: 'assets/sub.jpg',
  // // ),
  // // // BuildingInfo(
  // // //   name: 'Agronomy/Horticulture Building',
  // // //   description: "",
  // // //   imageUrl: 'assets/sub.jpg',
  // // // ),
  // BuildingInfo(
  //   name: 'Beef Cattle Center Building',
  //   description: "",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'New Deal Sow Boar Building',
  //   description: '',
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Junction Dining Hall Building',
  //   description: "",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Junction Academic Building',
  //   description: "",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Junction Administration Building',
  //   description: "",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Junction Maintenance Building',
  //   description: "",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'Forensic Sciences Building',
  //   description: "We are a dynamic and diverse program with faculty from a range of forensic disciplines, ranging from forensic chemistry to psychology.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // BuildingInfo(
  //   name: 'TTU Health Sciences Center (TTUHSC)',
  //   description: "The Texas Tech University Health Sciences Center, a separate university located on the same campus as Texas Tech, is made up of the Schools of Medicine, Nursing, Pharmacy, Allied Health Sciences and Biomedical Sciences.",
  //   imageUrl: 'assets/sub.jpg',
  //     hours: "8am 12pm",
  //     address:  "fdvr"
  // ),
  // Add more building info...
];