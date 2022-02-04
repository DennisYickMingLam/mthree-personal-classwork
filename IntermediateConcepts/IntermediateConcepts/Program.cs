using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace IntermediateConcepts
{

    #region Structures
    //Structures are Value type and go on the stack!!!
    //Structures can only implement interfaces and cannot
    //inherit from a class
    //have PhoneBook1 try to inherit from Name class
    public class Name
    {
        public string  FirstName { get; set; }
        public string  LastName { get; set; } 
    }

    public struct PhoneBook
    {
        public string Name;
        public string Phone;
        public string Email;

        //constructors must pass arguments and you must  
        //assign a value to every property in the struct.
        public PhoneBook(string firstname, string lastname, string eAddress, string phone)
        {
            //comment out next line to see the error
            Name = firstname + " " + lastname;
            Phone = phone;
            Email = eAddress;
        }

        //here is a method to use in our struct
        public void Clear()
        {
            Name = "";
            Phone = "";
            Email = "";
        }
    }

    public struct ContactBook
    {
        public string Name { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
    }
    #endregion

    #region Generics & Stacks
    //let's create out own Stack class for ints
    public class Stack
    {
        private int[] _items;
        private int _nextIndex;

        public Stack(int maxItemCount)
        {
            // initialize the array to hold as many items
            // as specified
            _items = new int[maxItemCount];
        }

        public void Push(int item)
        {
            // push the item on
            _items[_nextIndex] = item;

            // get ready for the next item
            _nextIndex++;
        }

        public int Pop()
        {
            // can't return if we are empty
            if (_nextIndex == 0)
                throw new Exception("No items in the stack!");

            // decrement the index
            _nextIndex--;

            // pull out the item at that index
            int value = _items[_nextIndex];

            // clear the value in the array
            _items[_nextIndex] = 0;

            // return the item
            return value;
        }
    }

    //GenericStack class with objects
    public class GenericStack
    {
        private object[] _items;
        private int _nextIndex;

        public GenericStack(int maxItemCount)
        {
            // initialize the array to hold as many items
            // as specified
            _items = new object[maxItemCount];
        }

        public void Push(object item)
        {
            // push the item on
            _items[_nextIndex] = item;

            // get ready for the next item
            _nextIndex++;
        }

        public object Pop()
        {
            // can't return if we are empty
            if (_nextIndex == 0)
                throw new Exception("No items in the stack!");

            // decrement the index
            _nextIndex--;

            // pull out the item at that index
            object value = _items[_nextIndex];

            // clear the value in the array
            _items[_nextIndex] = 0;

            // return the item
            return value;
        }
    }

    //Stack class with <T> (for type) parameter  
    public class Stack<T>
    {
        //notice how we have substituted the int or object with 'T'
        private T[] _items;
        private int _nextIndex;

        public Stack(int maxItemCount)
        {
            // initialize the array to hold as many items
            // as specified
            _items = new T[maxItemCount];
        }

        public void Push(T item)
        {
            // push the item on
            _items[_nextIndex] = item;

            // get ready for the next item
            _nextIndex++;
        }

        public T Pop()
        {
            // can't return if we are empty
            if (_nextIndex == 0)
                throw new Exception("No items in the stack!");

            // decrement the index
            _nextIndex--;

            // pull out the item at that index
            T value = _items[_nextIndex];

            // clear the value in the array
            //notice how we are using default(T) - this assures that we get the correct 
            //default value for the data type being used Ex:  int = 0, string = ""
            _items[_nextIndex] = default(T);

            // return the item
            return value;
        }
    }
    #endregion

    #region Collections

    public class Galaxy
    {
        public string Name { get; set; }
        public int MegaLightYears { get; set; }
    }

    public class Product
    {
        public string UPCCode { get; set; }
        public string Name { get; set; }
        public decimal Price { get; set; }
    }

    #endregion

    #region LINQ

    public class Student
    {
        public int StudentID { get; set; }
        public string LastName { get; set; }
    }

    public class StudentCourse
    {
        public int StudentID { get; set; }
        public string CourseName { get; set; }
    }

    public class StudentMajor
    {
        public string LastName { get; set; }
        public string Major { get; set; }
    }

    public class Planets
    {
        public string Name { get; set; }
        public int Order { get; set; }
        public int Moons { get; set; }
        public bool IsDwarf { get; set; }
    }

    #endregion

    #region System IO

    public class Contact
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Street1 { get; set; }
        public string Street2 { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string ZipCode { get; set; }
    }

    #endregion


    class Program
    {
        static void Main(string[] args)
        {
            //PhoneBookStructure();
            //UseContactBook();
            //DateTimeConstructors();
            //TickTock();
            //ParsingDates();
            //GettingTodayNow();
            //GettingDateParts();
            //GettingTheDays();
            //TimeSpan();
            //AddingDateParts();
            //GenericsAndStacks();
            //ListCollections();
            //EmptyingAList();
            //GalaxiesGalore();
            //DictionaryCollection();
            //ASimpleQuery();
            //JoiningCollections();
            //MoreLINQQueries();
            //GroupBy();
            //LambdaExpressionsEtc();
            //AnonymousTypes();
            //CreatingAndWritingFiles();
            //ReadingFiles();
            //ReadingStructuredData();
            //DriveAndDirectoryInfo();
            //CreateAndDeleteDiectories();
            FilesAndFileInfo();            

            Console.ReadLine();
        }

        static void PhoneBookStructure() 
        {
            //using structure with constructor and new
            PhoneBook phoneBook1 = new PhoneBook("Frank", "Herbert", "sandworm@dune.com", "222-777-4444");
            Console.WriteLine($"Name:  {phoneBook1.Name}, Phone:  {phoneBook1.Phone}, Email:  {phoneBook1.Email}\n");

            //using structure without constructor or new, the constructor is not used
            //and properties must be assigned before using
            PhoneBook phoneBook2;
            //Console.WriteLine(phoneBook4.Name);
            phoneBook2.Name = "Brian Herbert";
            phoneBook2.Phone = "555-333-4444";
            phoneBook2.Email = "spice@dune.com";
            Console.WriteLine($"Name:  {phoneBook2.Name}, Phone:  {phoneBook2.Phone}, Email:  {phoneBook2.Email}\n");

            //we call a struct method like with a class
            //notice that we can call the method if we used new or not
            phoneBook1.Clear();
            phoneBook2.Clear();
            //and here we see that both instances of PhoneBook have been cleared
            Console.WriteLine($"Name:  {phoneBook1.Name}, Phone:  {phoneBook1.Phone}, Email:  {phoneBook1.Email}\n");
            Console.WriteLine($"Name:  {phoneBook2.Name}, Phone:  {phoneBook2.Phone}, Email:  {phoneBook2.Email}\n");
        }

        static void UseContactBook()
        {
            //just like any value type, it cannot be null unless we use ?
            ContactBook contact1 = new ContactBook();
            //contact1 = null;

            ContactBook? contact2 = new ContactBook();
            //contact2 = null;
        }

        //Structures are user-defined objects which are aka 'lite classes'
        //They are value type and have certain rules
        //.NET has many structures within the Framework with DateTime being 
        //one of the most popular, other structs:  Int32, Decimal, Double
        //Go to Object Browser to see the DateTime, Int32... structure
        //Notice how many constructors that DateTime has
        static void DateTimeConstructors()
        {
            DateTime date1 = new DateTime();
            Console.WriteLine($"{date1} - No Constructor Passed\n");

            //Year, Month, Day
            DateTime date2 = new DateTime(2022, 1, 25);
            Console.WriteLine($"{date2} - Passing Year, Month, Day\n");

            //Year, Month, Day, Hour, Minute, Second
            //notice how we pass ints and a date is returned        
            DateTime date3 = new DateTime(2022, 1, 25, 14, 29, 59);
            Console.WriteLine($"{date3} - Passing Year, Month, Day, Hour, Minue, Second\n");
        }

        //DateTime values are stored in Ticks (1 Tick = 100 nanoseconds)
        //and dates are interernally stored as the
        //number of ticks since midnight of January 1, 0001.
        static void TickTock()
        {
            //let's declare a date from beginning of century and get 
            //the number of ticks from then to now
            DateTime beginCentury = new DateTime(2001, 1, 1);
            DateTime currentDate = DateTime.Now;

            //Ticks is a long - Go to definition and see
            long elapsedTicks = currentDate.Ticks - beginCentury.Ticks;

            //we have the Ticks so now we can use the TimeSpan class
            //access the properties of TotalSeconds, Days, Minutes, etc.
            TimeSpan elapsedSpan = new TimeSpan(elapsedTicks);

            Console.WriteLine($"Elapsed from the beginning of the century to {currentDate}:");
            Console.WriteLine($"   {elapsedTicks} ticks");
            Console.WriteLine($"   {elapsedTicks * 100} nanoseconds");
            Console.WriteLine($"   {elapsedSpan.TotalSeconds} seconds");
            Console.WriteLine($"   {elapsedSpan.TotalMinutes} minutes");
            Console.WriteLine($"   {elapsedSpan.Days} days");
            Console.WriteLine($"   {elapsedSpan.Hours} hours");
            Console.WriteLine($"   {elapsedSpan.Minutes} minutes");
            Console.WriteLine($"   {elapsedSpan.Seconds} seconds");
        }

        static void ParsingDates()
        {
            //we don't have to use the new keyword when declaring a DateTime
            //The date is being passed as string and TryParse is static
            //Right click TryParse and Go To Definition
            //DateTime strDate1 = new DateTime(2021,8, 23);
            //NOTE:  TryParse is an example of polymorphism as it is 
            //implemented differently for int, double, DateTime, etc.
            string strDate1 = "01/25/2022";
            if (DateTime.TryParse(strDate1, out DateTime date1))
            {
                Console.WriteLine("{0} is a valid date", date1);                
            }

            //we are using inline variable declaration with date2
            string strDate2 = "January 25, 2022";
            if (DateTime.TryParse(strDate2, out DateTime date2))
            {
                Console.WriteLine("{0} is a valid date", date2);
            }

            string strDate3 = "2022-01-25T10:30:00";
            if (DateTime.TryParse(strDate3, out DateTime date3))
            {
                Console.WriteLine("{0} is a valid date", date3);
            }

            //It will parse a lot of formats but not them all...
            string strDate4 = "25 of January, 2022";
            if (DateTime.TryParse(strDate4, out DateTime date4))
            {
                Console.WriteLine("{0} is a valid date", date4);
            }
            else
            {
                Console.WriteLine("Oh dear!  What happened?");
            }
        }

        static void GettingTodayNow()
        {
            //why don't we have to create a 'new DateTime' object?
            //Go to definition and note that these are static properties
            //Current date with time to the millisecond
            Console.WriteLine(DateTime.Now);

            //Current date with time 12:00:00 AM
            Console.WriteLine(DateTime.Today);

            //Current date with time to the millisecond UTC
            Console.WriteLine(DateTime.UtcNow);
        }

        static void GettingDateParts()
        {
            DateTime date = DateTime.Parse("01/25/2022 3:30:00 PM");

            //all of these return ints
            Console.WriteLine(date.Year);    //2022
            Console.WriteLine(date.Month);   // 1
            Console.WriteLine(date.Day);     // 25
            Console.WriteLine(date.Hour);    // 15 Military Time
            Console.WriteLine(date.Minute);  // 30
            Console.WriteLine(date.Second);  // 0
        }

        static void GettingTheDays()
        {
            DateTime date = DateTime.Parse("01/25/2022 3:30:00 PM");

            //the DateTime, DayOfWeek property returns a DayOfWeek enum type
            //Right click DayOfWeek and Go To Definition to see the enum
            DayOfWeek day = date.DayOfWeek;
            switch (day)
            {
                case DayOfWeek.Saturday:
                case DayOfWeek.Sunday:
                    Console.WriteLine("Its the weekend!");
                    break;
                case DayOfWeek.Monday:
                    Console.WriteLine("It's Monday!  5 days till weekend!!");
                    break;
                default:
                    Console.WriteLine("Its a weekday.");
                    break;
            }

            //using the DayOfYear property       
            Console.WriteLine($"{date} is {date.DayOfYear} days into the calendar year");
        }

        static void TimeSpan()
        {
            DateTime startDate = DateTime.Today;

            //calculate startDate and EndDate that spans 30 days         
            TimeSpan trialPeriod = new TimeSpan(30, 0, 0, 0);
            DateTime endDate = startDate + trialPeriod;
            Console.WriteLine($"Free Trial Ends:  {endDate}");

            //check if it is 1/1/2022 and if not, we will get a TimeSpan
            //object by subtracting today(ticks) from 1/1/23(ticks)
            ////and then using the TimeSpan, Days property
            if (DateTime.Today.Month == 1 && DateTime.Today.Day == 1)
            {
                Console.WriteLine("Happy New Year!");
            }
            else
            {
                DateTime nextNewYear = new DateTime(DateTime.Today.Year + 1, 1, 1); //2023, 1, 1
                TimeSpan daysUntilNewYears = nextNewYear - DateTime.Today;
                Console.WriteLine($"There are {daysUntilNewYears.Days} days until New Years");
            }
        }

        static void AddingDateParts()
        {
            DateTime date = DateTime.Now;

            Console.WriteLine($"One year from today:  {date.AddYears(1).ToShortDateString()}");
            Console.WriteLine($"Two months from today:  {date.AddMonths(2).ToShortDateString()}");
            Console.WriteLine($"One and a half days from now:  {date.AddDays(1.5)}");
            Console.WriteLine($"Six hours earlier:  {date.AddHours(-6)}");
            Console.WriteLine($"One hundred and fifty minutes from now:  {date.AddMinutes(150)}");
            Console.WriteLine($"Thirty seconds from now:  {date.AddSeconds(30)}");
            Console.WriteLine($"8,000 milliseconds from now:  {date.AddMilliseconds(8000)}");
            Console.WriteLine($"50,000,000 ticks from now:  {date.AddTicks(50000000)}");
        }

        static void GenericsAndStacks()
        {
            //we  created a Stack class but it only supports ints
            Stack stack1 = new Stack(10);
            //  push 3 values onto the stack
            stack1.Push(10);
            stack1.Push(20);
            stack1.Push(30);
            Console.WriteLine($"Using our int Stack class!  Notice the LIFO!");
            Console.WriteLine($"{stack1.Pop()}, {stack1.Pop()}, {stack1.Pop()}");

            //let's try using our GenericStack class with ints
            GenericStack genericStack1 = new GenericStack(10);
            //  push 3 values onto the stack
            genericStack1.Push(10);
            genericStack1.Push(20);
            genericStack1.Push(30);
            genericStack1.Push(40);
            Console.WriteLine($"\nUsing our GenericStack class with ints!");
            Console.WriteLine($"{genericStack1.Pop()}, {genericStack1.Pop()}, {genericStack1.Pop()}");
            //if we want to declare an int variable we need to cast it with our GenericStack class
            int value1 = (int)genericStack1.Pop();

            //let's try using our GenericStack class with strings
            GenericStack genericStack2 = new GenericStack(10);
            //  push 3 values onto the stack
            genericStack2.Push("Ten");
            genericStack2.Push("Twenty");
            genericStack2.Push("Thirty");
            genericStack2.Push("Fourty");
            Console.WriteLine($"\nUsing our GenericStack class with strings!");
            Console.WriteLine($"{genericStack2.Pop()}, {genericStack2.Pop()}, {genericStack2.Pop()}");
            //if we want to declare a string variable we need to cast it with our GenericStack class
            string value2 = (string)genericStack2.Pop();

            //let's try using our GenericStack class with any data type
            GenericStack genericStack3 = new GenericStack(10);
            //push 3 values onto the stack and because we are using the object data type,
            //we are allowed to pass any data type without a compiler error 
            genericStack3.Push(10);
            genericStack3.Push("Twenty");
            genericStack3.Push(false);
            genericStack3.Push(101);
            genericStack3.Push("Fifty");
            genericStack3.Push(true);
            Console.WriteLine($"\nUsing our GenericStack class with objects!");
            Console.WriteLine($"{genericStack3.Pop()}, {genericStack3.Pop()}, {genericStack3.Pop()}");
            //the problem with this is that we are not strongly typed and lists
            //need to be the same data type in most operations

            //uncomment the following line to see the errors
            //Console.WriteLine($"{genericStack3.Pop() + genericStack3.Pop()}, {genericStack3.Pop() * genericStack3.Pop()}, {genericStack3.Pop()}");
            //if we want to declare a string variable we need to cast it with our GenericStack class

            ////Uncomment these lines and run to see the runtime error - notice no compile time error
            //Note: runtime errors are hard to track down
            //string value3 = (string)genericStack3.Pop();
            //int value4 = (int)genericStack3.Pop();
            //bool value5 = (bool)genericStack3.Pop();
            //Console.WriteLine($"{genericStack3.Pop()}, {genericStack3.Pop()}, {genericStack3.Pop()}");

            //now let's use the Stack<T> class
            //look at the differences at the Stack<T> class in the Generics & Stacks region
            Stack<int> stack2 = new Stack<int>(10);
            stack2.Push(10);
            stack2.Push(20);
            stack2.Push(30);
            stack2.Push(40);
            Console.WriteLine($"\nUsing our Stack<T> class we stay typed as an int!");
            Console.WriteLine($"Let's add them all together: {stack2.Pop() + stack2.Pop() + stack2.Pop()}");
            //because our new Stack<T> class is typed, we now get compile errors if we try to 
            //push to wrong data type - uncomment below to see 
            //stack2.Push(45.33);
            //stack2.Push("No Way!!");
            //stack2.Push(true);

            //also, there is no need to cast because we are typed now
            int value6 = stack2.Pop();
            Console.WriteLine($"\nWe didn't need to 'type' our variable to display:  {value6}");
        }

        static void ListCollections()
        {
            //List<T> is a generic collection which is commonly used as a replacement for a
            //standard array because it can grow and you can keep adding items without specifying a size
            List<int> list1 = new List<int>();
            list1.Add(1);
            list1.Add(2);
            list1.Add(3);
            list1.Add(4);
            int[] toAdd = { 5, 6, 7, 8 };
            // add all elements from toAdd to list1
            list1.AddRange(toAdd);
            //note that collections use Count instead of Length for the number of elements
            Console.WriteLine($"There are {list1.Count} items in our list!");
            //when interating through collections we use a foreach loop
            foreach (var item in list1)
            {
                Console.Write(item + " ");
            }

            //here we are auto-initializing a list
            List<string> list2 = new List<string>() { "One", "Two", "Three", "Four" };
            string[] moreStrings = { "Five", "Six", "Eight" };
            // add all elements from moreStrings to list2
            list2.AddRange(moreStrings);
            Console.WriteLine($"\n\nThere are {list2.Count} items in our list!");
            foreach (var item in list2)
            {
                Console.Write(item + " ");
            }

            //Why are we using 'var' in the for each loop
            //var was introduced in C# 3.0 to declare an implicit type of local variable
            //to hold any type of data.  In implicitly typed variables, the type of the
            //variable declared is decided by the compiler at compile time based on the
            //type of the value that the variable is initialized with.
            //By using 'var', we are giving full control to the C# compiler to
            //determine the data type of the local variable.

            Console.WriteLine("\n\nWe are missing Seven and need to insert between Six and Eight.");
            // insert Seven at index 6
            list2.Insert(6, "Seven");
            Console.Write(string.Join(", ", list2));

            //since List<T> is commonly used in place of arrays, let's see how easy it is
            //to convert a List<T> to an array
            int[] intArray = list1.ToArray();
            string[] strArray = list2.ToArray();
            Console.WriteLine($"\n\n{intArray} has these elements:  {string.Join(", ", intArray)}");
            Console.WriteLine($"{strArray} has these elements:  {string.Join(", ", strArray)}");
        }

        static void EmptyingAList()
        {
            List<int> numbers = new List<int>() { 2, 2, 2, 3, 4, 5, 5, 2, 6, 2, 7, 8, 2, 9 };
            //we want to remove the 2's from our list
            numbers.Remove(2);
            //we can use a for loop when interating through collections
            Console.WriteLine("We have too many twos!!");
            for (int i = 0; i < numbers.Count; i++)
            {
                Console.Write(numbers[i] + " ");
            }

            //using Remove() only removes the first, to remove all the 2's
            //we need to use RemoveAll() with a lambda to be passed as parameter
            //a lambda has a variable, for a single element in a collection, &
            //an action to perform on element, lambda method then iterates and performs
            //action on each element -for RemoveAll(), the action must be a boolean expression.
            //If the expression evaluates to true, the item will be removed.
            Console.WriteLine("\n\nRemoveAll() will get all of twos!!");


            numbers.RemoveAll(nums => nums == 2);



            Console.Write(string.Join(" ", numbers));
            Console.WriteLine("\n\nRemoveAt() will get rid of that extra five!!");


            //we are using IndexOf() to find the index for '5'
            numbers.RemoveAt(numbers.IndexOf(5));
            Console.Write(string.Join(" ", numbers));
        }

        static void GalaxiesGalore()
        {
            //Using a List<> for a class object
            //The Galaxy class is in the Collections region
            List<Galaxy> theGalaxies = new List<Galaxy>
            {
                new Galaxy() { Name="Tadpole", MegaLightYears=400},
                new Galaxy() { Name="Pinwheel", MegaLightYears=25},
                new Galaxy() { Name="Milky Way", MegaLightYears=0},
                new Galaxy() { Name="Andromeda", MegaLightYears=3}
            };
            Console.WriteLine($"There are {theGalaxies.Count} galaxies in our list!");
            //we can now loop thru the collection and access the class properties
            foreach (var theGalaxy in theGalaxies)
            {
                Console.WriteLine($"{theGalaxy.Name} galaxy is {theGalaxy.MegaLightYears} lightyears.");
            }
        }

        static void DictionaryCollection()
        {
            //Product class is in the Collections region
            //let's put the product class in a List<T>
            List<Product> products1 = new List<Product>()
            {
                new Product() { UPCCode = "0001", Name = "Bananas", Price = 1.99M },
                new Product() { UPCCode = "1313", Name = "Apples", Price = 3.49M },
                new Product() { UPCCode = "4249", Name = "Lettuce", Price = 0.78M },
                new Product() { UPCCode = "4576", Name = "Pears", Price = 3.99M },
                new Product() { UPCCode = "0002", Name = "Cherries", Price = 4.89M },
                new Product() { UPCCode = "0033", Name = "Kiwi", Price = 2.50M }
            };
            //to locate a specific product we would have to loop thru, however, it is an O(n)
            //lookup and processing increases as the input increases
            string upcCode = "1313";
            foreach (var product in products1)
            {
                if (product.UPCCode == upcCode)
                {
                    Console.WriteLine($"Just found product, {product.Name}, with UPC Code:  {product.UPCCode}");
                }
            }

            //let's fix this with a Dictionary<TKey, TValue> collection where we can have a O(1) lookup time
            //because we can do a direct lookup
            Dictionary<string, Product> products2 = new Dictionary<string, Product>();
            products2.Add("0001", new Product() { UPCCode = "0001", Name = "Bananas", Price = 1.99M });
            products2.Add("1313", new Product() { UPCCode = "1313", Name = "Apples", Price = 3.49M });
            products2.Add("4249", new Product() { UPCCode = "4249", Name = "Lettuce", Price = 0.78M });
            products2.Add("4576", new Product() { UPCCode = "4576", Name = "Pears", Price = 3.99M });
            products2.Add("0002", new Product() { UPCCode = "0002", Name = "Cherries", Price = 4.89M });
            products2.Add("0033", new Product() { UPCCode = "0033", Name = "Kiwi", Price = 2.50M });

            //values are accessed by putting the key in square brackets []
            Product value = products2["4576"];
            Console.WriteLine($"\nRetrieved {value.Name} from Dictionary and now we know the price: {value.Price:C}");

            //we can remove an entry by key too, notice how we are using () to Remove() instead of []
            Console.WriteLine($"\nWe will remove {products2["4576"].Name} from our Dictionary.\n");
            products2.Remove("4576");

            //iterating through a Dictionary with a foreach loop
            foreach (KeyValuePair<string, Product> kvp in products2)
            {
                Console.WriteLine($"Product: {kvp.Value.Name}, Price: {kvp.Value.Price:C}");
            }

            Console.WriteLine("");

            //but the preferred method is LINQ - iterating through Key Value Pairs
            products2.ToList().ForEach(kvp =>
                { Console.WriteLine($"Key: {kvp.Key}, Product: {kvp.Value.Name}, Price: {kvp.Value.Price:C}"); });

            Console.WriteLine("");

            //iterating through only the Values
            products2.Select(kvp => kvp.Value).ToList().ForEach(v =>
                { Console.WriteLine($"{v.Price:C} is too much for {v.Name}"); });

            //ContainsKey()
            if (products2.ContainsKey("0002"))
            {
                Console.WriteLine("\nLooks like we can have a bowl filled with cherries!!");
            }

            //using a Dictionary to count 'occurrances'
            //this foreach loop will create a Dictionary that has the character for 
            //the key and the number of times it occurs as the value
            string input = "How many times does 'm' appear in this sentence?";
            Dictionary<char, int> letterCounts = new Dictionary<char, int>();
            foreach (char m in input)
            {
                // do we already have this letter?
                if (letterCounts.ContainsKey(m))
                {
                    letterCounts[m]++;
                }
                else
                {
                    // first time we have had this letter
                    letterCounts.Add(m, 1);
                }
            }
            int mCount = letterCounts['m'];
            Console.WriteLine($"\nInput: {input}\nLooking for how many times 'm' appears: {mCount}");

        }

        static void ASimpleQuery()
        {
            //right click on List to see that is has implemented the IEnumerable interface
            //objects that have implemented IEnumerable can be looped through
            List<int> allNumbers = new List<int>() { 4, 2, 3, 7, 15, 20, 6 };

            //let's get the odd numbers using a loop
            List<int> onlyOdds1 = new List<int>();
            foreach (int number in allNumbers)
            {
                // check if current element is odd
                if (number % 2 == 1)
                    onlyOdds1.Add(number);
            }
            Console.WriteLine($"Finding Odds With Loop:  {string.Join(" ", onlyOdds1)}");

            //now let's use LINQ query syntax
            //even though we don't have a loop coded, LINQ is looping under the hood
            var onlyOdds2 = from num in allNumbers  //from element in collection.
                            where num % 2 == 1
                            select num;
            Console.WriteLine($"\nFinding Odds With LINQ Query Syntax:  {string.Join(" ", onlyOdds1)}");

            //just a note about the var keyword, you must initialize and assign a value immediately
            // C# looks at the assignment and decides y is an int
            //var y = 5;

            //Query result types can be a collection(enumeration) or a single aggregate(scalar)
            // Enumerable, with 0 to many results
            IEnumerable<int> onlyOdds3 = allNumbers.Where(number => number % 2 == 1);
            // scalar, there is only one count
            int howManyOdds = onlyOdds3.Count();
            // scalar, there is only one max
            int biggestOdd = onlyOdds3.Max();

            Console.WriteLine($"\nEnumeration: {string.Join(" ", onlyOdds3)}\nScalar: {onlyOdds3.Count()}" +
                $"\nScalar: {onlyOdds3.Max()}");

            //what if we return nothing
            IEnumerable<int> empty = allNumbers.Where(number => number > 20);
            if (empty.Any())
            {
                Console.WriteLine("\nWe have a collection that is not empty.");
            }
            else
            {
                Console.WriteLine("\nWe didn't return anything, but we didn't blow up!!");
            }

        }

        //we will use LINQ to query and join these collections
        public static List<Student> students = new List<Student>
            {
                new Student { LastName = "Smith", StudentID = 1 },
                new Student { LastName = "Jones", StudentID = 2 }
            };
        public static List<StudentCourse> courses = new List<StudentCourse>
            {
                new StudentCourse { StudentID = 1, CourseName = "C# Fundamentals" },
                new StudentCourse { StudentID = 1, CourseName = "ASP.NET Fundamentals" },
                new StudentCourse { StudentID = 2, CourseName = "Java Fundamentals" },
                new StudentCourse { StudentID = 2, CourseName = "CSS Fundamentals" }
            };
        public static List<StudentMajor> studentMajors = new List<StudentMajor>
        {
            new StudentMajor { LastName = "Sandler", Major = "Computer Science" },
            new StudentMajor { LastName = "Martin", Major = "History" },
            new StudentMajor { LastName = "Murphy", Major = "English" },
            new StudentMajor { LastName = "Herbert", Major = "History" },
            new StudentMajor { LastName = "Adams", Major = "English" },
            new StudentMajor { LastName = "Pacino", Major = "Computer Science" },
            new StudentMajor { LastName = "Candy", Major = "History" },
        };

        static void JoiningCollections()
        {
            //we are using anonymous types, we can create a new type(class) in the select statement
            //which contains only we want, we will use the new keyword and list out the properties
            //and data that we want to create - note the var keyword
            var results = from student in students
                          join course in courses
                          on student.StudentID equals course.StudentID
                          select new
                          {
                              StudentID = student.StudentID,
                              LastName = student.LastName,
                              CourseName = course.CourseName
                          };

            //let's print out our result
            Console.WriteLine("{0, -10} {1,-10} {2}", "StudentID", "LastName", "CourseName");
            foreach (var row in results)
            {
                Console.WriteLine($"{row.StudentID,-10} {row.LastName,-10} {row.CourseName}");
            }

            //Anonymous types can only be used in the local variable scope where they are defined.
            //If you do use a data structure in multiple places, you should define a class.
        }

        static void MoreLINQQueries()
        {
            //query structure using a where clause
            //From....  Where....   Select....
            var results1 = from student in students
                           join course in courses
                           on student.StudentID equals course.StudentID
                           where student.LastName == "Smith"
                           select new
                           {
                               StudentID = student.StudentID,
                               LastName = student.LastName,
                               CourseName = course.CourseName
                           };
            Console.WriteLine("{0, -10} {1,-10} {2}", "StudentID", "LastName", "CourseName");
            foreach (var row in results1)
            {
                Console.WriteLine($"{row.StudentID,-10} {row.LastName,-10} {row.CourseName}");
            }

            //using Orderby
            //From...  Where...  Orderby...  Select...
            var results2 = from student in students
                           join course in courses
                           on student.StudentID equals course.StudentID
                           where student.LastName == "Smith"
                           orderby course.CourseName ascending
                           select new
                           {
                               StudentID = student.StudentID,
                               LastName = student.LastName,
                               CourseName = course.CourseName
                           };
            Console.WriteLine("\n{0, -10} {1,-10} {2}", "StudentID", "LastName", "CourseName");
            foreach (var row in results2)
            {
                Console.WriteLine($"{row.StudentID,-10} {row.LastName,-10} {row.CourseName}");
            }
        }

        static void GroupBy()
        {
            //we want to return a 'report' with the students grouped by major
            //this what returns with no grouping or ordering
            var result1 = from student in studentMajors
                          select student;

            Console.WriteLine("{0, -10} {1,-16}", "Student", "Major");
            Console.WriteLine("{0, -10} {1,-16}", "----------", "-----------------");
            foreach (var row in result1)
            {
                Console.WriteLine($"{row.LastName,-10} {row.Major,-10}");
            }

            Console.WriteLine("");

            //this LINQ will return our data so we can display grouped and sorted
            var result2 = from student in studentMajors
                          orderby student.Major, student.LastName
                          group student by student.Major;

            //the value of field we grouped by is the 'Key'
            foreach (var group in result2)
            {
                Console.WriteLine($"{group.Key}");
                foreach (var student in group)
                {
                    Console.WriteLine($"     {student.LastName}");
                }
            }
        }

        static void LambdaExpressionsEtc()
        {
            //For complicated queries, Microsoft recommends using query syntax because it is more readable
            //and states your intentions, but for a simple expression to find the odd values,
            //we can do this use a lambda expression:
            List<int> allNumbers = new List<int>() { 4, 2, 3, 7, 15, 20, 6 };
            var onlyOdds = allNumbers.Where(number => number % 2 == 1);
            Console.WriteLine($"{string.Join(" ", onlyOdds)}\n");

            //Method syntax uses lambda expressions in which we define a variable name
            //then we use the lambda arrow to define an expression or action to be taken
            //An expression like "number % 2 == 1" in a lambda, which returns true or false
            //it is referred to as a predicate.

            //in our List<StudentMajor> we want to remove Murphy
            studentMajors.RemoveAll(s => s.LastName == "Murphy");
            foreach (var stud in studentMajors)
            {
                Console.WriteLine($"Name: {stud.LastName}, Major: {stud.Major}");
            }

            Console.WriteLine("");

            //now we want only the History majors
            var result1 = studentMajors.Where(s => s.Major == "History");
            foreach (var stud in result1)
            {
                Console.WriteLine($"Name: {stud.LastName}, Major: {stud.Major}");
            }

            Console.WriteLine("");

            //now let's retrieve one student
            StudentMajor candy = studentMajors.FirstOrDefault(s => s.LastName == "Candy");
            Console.WriteLine($"Name: {candy.LastName}, Major: {candy.Major}\n");

            //example of ToDictionary
            Dictionary<string, StudentMajor> studentDictionary = studentMajors.ToDictionary(x => x.LastName);
            studentDictionary.ToList().ForEach(kvp =>
            { Console.WriteLine($"Key: {kvp.Key}, Name: {kvp.Value.LastName}, Major: {kvp.Value.Major}"); });
        }

        public static List<Planets> planets = new List<Planets>
        {
            new Planets { Name = "Mercury", Order = 1, Moons = 0, IsDwarf = false },
            new Planets { Name = "Venus", Order = 2, Moons = 0, IsDwarf = false },
            new Planets { Name = "Earth", Order = 3, Moons = 1, IsDwarf = false },
            new Planets { Name = "Mars", Order = 4, Moons = 2, IsDwarf = false },
            new Planets { Name = "Ceres", Order = 5, Moons = 0, IsDwarf = true },
            new Planets { Name = "Jupiter", Order = 6, Moons = 69, IsDwarf = false },
            new Planets { Name = "Saturn", Order = 7, Moons = 62, IsDwarf = false },
            new Planets { Name = "Uranus", Order = 8, Moons = 27, IsDwarf = false },
            new Planets { Name = "Neptune", Order = 9, Moons = 14, IsDwarf = false },
            new Planets { Name = "Pluto", Order = 10, Moons = 5, IsDwarf = true }
        };

        static void AnonymousTypes()
        {
            //let's revisit anonymous types using query syntax and method syntax
            //what makes our result an anonymous type is the 'new' keyword
            //complex queries normally use query syntax and simple queries method syntax

            //anonymous type using a lambda
            //return a list of planets that have no moon sorted by order from sun  
            var results1 = planets.Where(n => n.Moons == 0).OrderBy(o => o.Order).Select(
                p => new 
                { 
                    Planet = p.Name 
                });
            foreach (var p in results1)
            {
                Console.WriteLine(p.Planet);
            }

            Console.WriteLine("");

            //anonymous type using query syntax
            //return the name and number of moons from the planets that are not dwarf sorted by order
            var results2 = from planet in planets
                           where planet.IsDwarf == false
                           orderby planet.Order ascending
                           select new
                           {
                               Planet = planet.Name,
                               Moons = planet.Moons
                           };
            string line1 = "{0,-10} {1,6}";
            Console.WriteLine(line1, "Planet", "Moons");
            foreach (var planet in results2)
            {
                Console.WriteLine(line1, planet.Planet, planet.Moons);
            }

            Console.WriteLine("");

            //return the name, number of moons and Is Dwarf field indicating yes or no sorted by order
            //we are also using a ternary expression for the IsDwarf field in our anonymous type
            var results3 = planets.OrderBy(o => o.Order).Select(
                p => new {
                    Planet = p.Name,
                    Moons = p.Moons,
                    IsDwarf = p.IsDwarf == true ? "Yes" : "No"
                });
            string line2 = "{0,-10} {1,6} {2, 10}";
            Console.WriteLine(line2, "Planet", "Moons", "Is Dwarf");
            foreach (var planet in results3)
            {
                Console.WriteLine(line2, planet.Planet, planet.Moons, planet.IsDwarf);
            }

            // in your next assessment, you will be working with LINQ
            // here is a list of some of the LINQ/IEnumerable methods that you will need 
            // to use that have not been included in our examples:
            //
            // Take() - return specified number of elements from start of sequence
            // Skip() - bypasses a specified number of elements from start of sequence
            // TakeWhile() - returns elements in a sequence up to a specified condition being true
            //   then returns the remaining elements
            // SkipWhile() - bypasses elements in a sequence up to a specified condition being true
            //   then returns the remaining elements
            // OrderByDescending()
            // ThenByDescending()
            // Reverse()
            // Distinct()
        }

        static void CreatingAndWritingFiles()
        {
            //Click on See All Files in Solution Explorer and go to
            // bin\Debug - run program and see the txt be created
            // the . means that we are in the directory our .exe is in
            string path1 = @".\List.txt";

            //var listtxt = File.Create(path1);
            //Console.WriteLine("List.txt has been created.");
            //////when we use File.Create we must close it before we can write to it
            //listtxt.Close();

            ////if we don't want to overwrite the existing file we can do a check
            //if (!File.Exists(path1)) {
            //    var list = File.Create(path1);
            //    list.Close();
            //}


            //let's create and write to a file, Colors.txt using WriteAllLines
            string path2 = @".\Colors.txt";
            //string[] lines = new string[]
            //{
            //    "Blue",
            //    "Green",
            //    "Yellow",
            //    "Red",
            //    "Orange"
            //};
            //File.WriteAllLines(path2, lines);
            //Console.WriteLine("Colors.txt has been created and written to.");

            //using, the using statement is very important because it will
            //close the file, etc. for us and dispose of objects             
            //forgetting to close a file will lock it and prevent other apps or users from opening it

            //using the streamwriter class, with a using statement!!
            //uncomment and run so we can see that the WriteLine() overwrites an
            //the existing data on Colors.txt
            //using (StreamWriter writer = new StreamWriter(path2)) {
            //    writer.WriteLine("Red");
            //    writer.WriteLine("Green");
            //    writer.WriteLine("Yellow");
            //    writer.WriteLine("Blue");
            //}

            ////the AppendText allows us to add to existing data
            //using (StreamWriter writer = File.AppendText(path2)) {
            //    writer.WriteLine("Gray");
            //    writer.WriteLine("Purple");
            //    writer.WriteLine("Pink");
            //}
            //Console.WriteLine("Colors.txt has been appended to.");

            using (StreamWriter writer = File.AppendText(path1)) {
                writer.WriteLine("When we use the Streamwriter with the File.AppendText,");
                writer.WriteLine("the text is not overwritten but added to the end.");
            }
        }

        static void ReadingFiles()
        {
            //reading using ReadAllLines()
            string path1 = @".\Colors.txt";
            string[] allLines = File.ReadAllLines(path1);

            foreach (string line in allLines)
            {
                Console.WriteLine(line);
            }

            Console.WriteLine("");

            //using the Streamreader
            using (StreamReader reader = new StreamReader(path1))
            {
                string line;
                while ((line = reader.ReadLine()) != null)
                {
                    Console.WriteLine(line);
                }
            }
        }

        static void ReadingStructuredData()
        {
            string path = @".\AddressBook.txt";

            if (File.Exists(path))
            {
                Console.WriteLine($"Found the file at {path}\n");
            }
            else
            {
                Console.WriteLine($"Could not find the file at {path}\n");
            }

            //using the ReadAllLines the data returns like this
            string[] rows = File.ReadAllLines(path);
            foreach (var row in rows)
            {
                Console.WriteLine(row.ToString());
            }

            Console.WriteLine("");

            //using the Contact class in the System IO region
            //let's make a List<Contact> object, we start at 1 because we don't
            //want to read the header row
            List<Contact> contacts = new List<Contact>();
            for (int i = 1; i < rows.Length; i++)
            {
                string[] columns = rows[i].Split(',');

                Contact cont = new Contact();
                cont.FirstName = columns[0];
                cont.LastName = columns[1];
                cont.Street1 = columns[2];
                cont.Street2 = columns[3];
                cont.City = columns[4];
                cont.State = columns[5];
                cont.ZipCode = columns[6];

                contacts.Add(cont);
            }

            // print the contacts and use LINQ to sort
            foreach (var contact in contacts.OrderBy(c => c.LastName))
            {
                Console.WriteLine($"{contact.LastName}, {contact.FirstName}");
                Console.WriteLine(contact.Street1);

                if (!string.IsNullOrEmpty(contact.Street2))
                {
                    Console.WriteLine(contact.Street2);
                }
                Console.WriteLine($"{contact.City}, {contact.State} {contact.ZipCode}\n");
            }
        }

        static void DriveAndDirectoryInfo()
        {
            //DriveInfo class
            DriveInfo oneDrive = new DriveInfo("C");
            DriveInfo[] allDrives = DriveInfo.GetDrives();

            foreach (var drive in allDrives)
            {
                // [1] Print Sizes.
                Console.WriteLine($"Available Free Space: {drive.AvailableFreeSpace/1024/1024/1024}GB");
                Console.WriteLine($"Total Free Space: {drive.TotalFreeSpace/1024/1024/1024}GB");
                Console.WriteLine($"Total Size: {drive.TotalSize/1024/1024/1024}GB");
                // [2] Format and type.
                Console.WriteLine($"Format: {drive.DriveFormat}");
                Console.WriteLine($"Type: {drive.DriveType}");
                // [3] Name and directories
                Console.WriteLine($"Drive Name: {drive.Name}");
                Console.WriteLine($"Root Directory: {drive.RootDirectory}");
                Console.WriteLine($"Volume Label: {drive.VolumeLabel}");
                Console.WriteLine($"Is Ready: {drive.IsReady}");
            }


            //DirectoryInfo class - look at System32 directory 
            DirectoryInfo dir1 = new DirectoryInfo(@"C:\Windows\System32");
            Console.WriteLine("\n****** Directory Info ******");
            Console.WriteLine($"FullName: {dir1.FullName}");
            Console.WriteLine($"Name: {dir1.Name}");
            Console.WriteLine($"Parent: {dir1.Parent}");
            Console.WriteLine($"Creation: {dir1.CreationTime}");
            Console.WriteLine($"Attributes: {dir1.Attributes}");
            Console.WriteLine($"Root: {dir1.Root}");
            Console.WriteLine("***************************\n");

            //look at our app directory
            DirectoryInfo dir2 = new DirectoryInfo(@".");
            Console.WriteLine("\n****** Directory Info ******");
            Console.WriteLine($"FullName: {dir2.FullName}");
            Console.WriteLine($"Name: {dir2.Name}");
            Console.WriteLine($"Parent: {dir2.Parent}");
            Console.WriteLine($"Creation: {dir2.CreationTime}");
            Console.WriteLine($"Attributes: {dir2.Attributes}");
            Console.WriteLine($"Root: {dir2.Root}");
            Console.WriteLine("***************************\n");
        }

        static void CreateAndDeleteDiectories()
        {
            // get the current application directory        
            DirectoryInfo myDirectory = new DirectoryInfo(".");

            // Create \MyFolder off the initial directory.
            DirectoryInfo folder1 = myDirectory.CreateSubdirectory("MyFolder1");
            Console.WriteLine($"New Folder is: {folder1}\n");

            // create a new DirectoryInfo object for our
            //new directory with a more complex path
            DirectoryInfo folder2 = myDirectory.CreateSubdirectory(@"MyFolder2\Data\Lists");            
            Console.WriteLine($"New Folder is: {folder2}\n");

            //to Delete() a directory, it cannot have subdirectories
            DirectoryInfo dir1 = new DirectoryInfo(@".\MyFolder1");
            dir1.Delete();
            Console.WriteLine($"{folder1} has been DELETED!\n");

            //unless you pass the bool param true, which specifies whether you
            // wish to destroy any subdirectories
            DirectoryInfo dir2 = new DirectoryInfo(@".\MyFolder2");
            dir2.Delete(true);
            Console.WriteLine($"{folder2} has been DELETED!\n");
        }

        static void FilesAndFileInfo()
        {
            //go to windows explorer and verify you have this directory
            //using DirectoryInfo, we can get info for files by using 
            //GetFiles() and assigning to a FileInfo object
            DirectoryInfo dir = new DirectoryInfo(@"C:\Windows\Web\Wallpaper");
            // Get all files with a *.jpg extension
            FileInfo[] imageFiles = dir.GetFiles("*.jpg", SearchOption.AllDirectories);
            // How many were found?
            Console.WriteLine($"Found {imageFiles.Length} *.jpg files \n");

            //Now print out info for each file
            foreach (FileInfo file in imageFiles)
            {
                Console.WriteLine("**********************");
                Console.WriteLine($"File Name: {file.Name}");
                Console.WriteLine($"File Size: {file.Length/1024}KB");
                Console.WriteLine($"Created: {file.CreationTime}");
                Console.WriteLine($"Attributes: {file.Attributes}\n");              
            }

            //determining if FileInfo object is a file or directory
            FileInfo fi1 = new FileInfo(@"C:\Windows\Web\Wallpaper");
            //one of the few times you will use a bitwise operator
            if ((fi1.Attributes & FileAttributes.Directory) == FileAttributes.Directory)
            {
                Console.WriteLine($"{fi1.Name} is a directory, not a file");
            }
            else
            {
                Console.WriteLine($"{fi1.Name} is a file");
            }

            FileInfo fi2 = new FileInfo(@".\Colors.txt");
            if ((fi2.Attributes & FileAttributes.Directory) == FileAttributes.Directory)
            {
                Console.WriteLine($"{fi2.Name} is a directory, not a file");
            }
            else
            {
                Console.WriteLine($"{fi2.Name} is a file");
            }

        }
    }
}
    
