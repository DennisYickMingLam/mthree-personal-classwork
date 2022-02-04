using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Text.RegularExpressions;

namespace AdvancedConcepts
{
    #region Exceptions

    public class NumberGenerator
    {
        int[] numbers = { 2, 4, 6, 8, 10, 12, 14, 16, 18, 20 };

        //we check our condition and throw the exception from the GetNumber method
        public int GetNumber(int index)
        {
            if (index < 0 || index >= numbers.Length)
            {
                throw new IndexOutOfRangeException();
            }
            return numbers[index];
        }
    }

    //we will inherit from the Exception class..  Go to Definition
    public class OddNumberException : Exception
    {
        //Overriding the virtual Message property
        public override string Message
        {
            get
            {
                return "Divisor cannot be odd number!!";
            }
        }
    }
    #endregion

    #region Interfaces
    //this is just an example of creating and using an interface
    //in a class, we will see it in more detail when we 
    //look at the loosely coupled RPS
    //there is no implementation or body for the methods
    interface IOne
    {
        void Method1();
        void Method2();
    }

    //here is an example of an interface implementing another interface
    //so now this interface also has the methods in IOne
    interface ITwo : IOne
    {
        void Method3();
    }

    //now let's create a MyClassOne and implement ITwo, which is implementing IOne
    //notice how we need to implement all 3 methods
    public class MyClassOne : ITwo
    {
        public void Method1()
        {
            Console.WriteLine("Implemented Method1(), which is defined in IOne!!");
        }

        public void Method2()
        {
            Console.WriteLine("Implemented Method2(), which is defined in IOne!!");
        }

        public void Method3()
        {
            Console.WriteLine("Implemented Method3(), which is defined in ITwo!!");
        }
    }

    ////uncomment the classes and hold cursor over red squigglies, then implement
    ////so you can see how .NET will create a scaffolding for you   
    ////
    //public class MyClassTwo : IOne
    //{

    //}
    ////
    //public class MyClassThree : ITwo
    //{

    //}

    public class MovieRating : IComparable<MovieRating>
    {
        public string Title { get; set; }
        public int Rating { get; set; }

        public int CompareTo(MovieRating other)
        {
            // TODO: write our comparison logic.
            if (this.Rating < other.Rating) return -1;
            if (this.Rating == other.Rating) return 0;
            return 1;
        }
    }

    //the MovieRating class implements the IComparable<MovieRating> for 
    //sorting movies by the Rating which is an int with the CompareTo() method
    //we will rank movies based on rating...  if a movie is rated lower, it's smaller
    //if it's rated higher, it's bigger

    //right click and go to defintion of IComparable... it is used to compare objects for sorting
    //and has only 1 method to implement, CompareTo(), which returns an int
    //-1 - instance precedes other in the sort order (less than 0)
    // 0 - both instances occurs in the same position in the sort order
    // 1 - instance follows other in the sort order (greater than 0)
    #endregion

    class Program
    {
        static void Main(string[] args)
        {
            DivideByZeroUnhandled();
            //DivideByZeroIsFun();
            //FileNotFoundIsFunToo();
            //ThrowingAnException();
            //UsingCustomException();
            //InnerExceptionExample();
            //MyClassAndInterfaces();
            //ImplementingInterfaces();


            Console.ReadLine();
        }

        static void DivideByZeroUnhandled()
        {
            int x = 5;
            int y = 0;

            // this will crash the program
            Console.WriteLine(x / y);
        }

        static void DivideByZeroIsFun()
        {
            //swallowing an exception..  Don't do
            try
            {
                DivideByZeroUnhandled();
            }
            catch
            {
            }
            Console.WriteLine("We swallowed the above exception.\nWe don't even know that an exception was thrown\nor that our method call was unsuccessful.");

            //try...  catch...  bare bones exception, hardly ever used
            try
            {
                DivideByZeroUnhandled();
            }
            catch //no exception parameter is passed
            {
                Console.WriteLine("\nWell,we know we threw an exception, but that's really all we know!!");
            }

            //this time we will pass an exception parameter at the catch so we can access the
            ////exception properties...    and we add a finally
            try
            {
                DivideByZeroUnhandled();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"\nNow we can get information about the exception.\n\nMESSAGE: {ex.Message}\nTYPE: {ex.GetType()}\nSTACK TRACE: {ex.StackTrace}\nSOURCE: {ex.Source}\nBASE EXCEPTION: {ex.GetBaseException()}\n");
            }
            finally
            {
                Console.WriteLine($"The finally block will run if we do or don't catch an exception!!");
            }

            //now let's add an additional catch so we can use specific divide by zero exception or
            //a general exception... note the catch block that caught the exception
            try
            {
                DivideByZeroUnhandled();
            }
            catch (DivideByZeroException ex)
            {
                Console.WriteLine($"\nType: {ex.GetType()}\nMessage: {ex.Message} - First Catch Block\n");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"\nType: {ex.GetType()}\nMessage: {ex.Message} - Second Catch Block\n");
            }
            finally
            {
                Console.WriteLine($"And we will use the finally block to tell user to stop trying to divide by zero!!");
            }

        }

        static void FileNotFoundIsFunToo()
        {
            string filepath = @".\test.txt";
            //bare bones
            try
            {
                string[] text = File.ReadAllLines(filepath);
            }
            catch
            {
                Console.WriteLine("Oh dear, an error occurred while calling the File.ReadAllLines and that is all we know.\n");
            }

            //passing an exception parameter - this gives us more info 
            try
            {
                string[] text = File.ReadAllLines(filepath);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"MESSAGE: {ex.Message}\n");
                Console.WriteLine($"STACK TRACE: {ex.StackTrace}");
            }

            //let's add the FileNotFoundException and filter down
            //we also will add a finally which when doing file or database 
            //operations is vital
            FileStream file = null;
            try
            {
                file = File.Open(filepath, FileMode.Open);
            }
            // Specific exception, catches only file not found
            catch (FileNotFoundException ex)
            {
                Console.WriteLine($"\nMESSAGE:  {ex.Message}  \nFILE:  {filepath} was not found.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"\nAn error occurred reading the file: {ex.Message}");
            }
            finally
            {
                // is file open? Close it!
                if (file != null)
                    file.Close();
            }

        }

        static void ThrowingAnException()
        {
            //go to region Exceptions and look at the NumberGenerator class to 
            //see how we are throwing the exception from there
            //in C#, throwing exceptions is rarely done, notice that the stack trace is
            //starting from when the exception was thrown
            var gen = new NumberGenerator();
            int index = 10;
            try
            {
                int value = gen.GetNumber(index);
                Console.WriteLine($"Retrieved {value}");
            }
            catch (IndexOutOfRangeException ex)
            {
                Console.WriteLine($"{ex.GetType().Name}: {index} is outside the bounds of the array");
                Console.WriteLine($"\nStack Trace: {ex.StackTrace}");
            }
            //good practice, when using specific exception always include a generic exception to 
            //catch unanticipated exceptions
            catch (Exception ex)
            {
                Console.WriteLine($"{ex.GetType().Name}: {ex.Message}");
                Console.WriteLine($"\nStack Trace: {ex.StackTrace}");
            }
            finally
            {
                Console.WriteLine("\nThe exception happened and was thrown from the GetNumber() method" +
                    " for us to catch and handle in this method!!\nIt Bubbled Up!!");
            }
        }

        //Enter first:  5, 3 - Enter second: 4, hello - Enter third: 5,0 -
        //Enter fourth:  9999999999
        //of course in reality, we would validate user input...  for demo only!!
        static void UsingCustomException()
        {
            //go to region Exceptions and look at the OddNumberException class, it
            //inherits the Exception class and see how we overrides the Message property
            int x, y, z;
            Console.WriteLine("Enter 2 Integers:");
            try
            {
                Console.WriteLine("Enter First:");
                x = int.Parse(Console.ReadLine());
                Console.WriteLine("Enter Second:");
                y = int.Parse(Console.ReadLine());
              
                if (y % 2 > 0)
                {
                    //we will throw our custom exception from the try
                    throw new OddNumberException();
                }
                z = x / y;
                Console.WriteLine($"{x} Divided By {y} = {z}");
            }
            catch (OddNumberException ex)
            {
                Console.WriteLine("Caught By 1st Catch:  " + ex.Message);
            }
            catch (FormatException ex)
            {
                Console.WriteLine("Caught By 2nd Catch:  " + ex.Message);
            }
            catch (DivideByZeroException ex)
            {
                Console.WriteLine("Caught By 3rd Catch:  " + ex.Message);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Caught By 4th Catch:  " + ex.Message);
            }
            finally
            {
                Console.WriteLine($"Thanks for playing!!");
            }
        }

        //Enter 5,0 | 5,hello | 9999999999 - to see the inner exceptions
        static void InnerExceptionExample()
        {
            try
            {
                try
                {
                    int x, y;
                    Console.WriteLine("Enter 2 Integers:");
                    Console.WriteLine("Enter First:");
                    x = int.Parse(Console.ReadLine());
                    Console.WriteLine("Enter Second:");
                    y = int.Parse(Console.ReadLine());
                    int result =x / y;
                    Console.WriteLine($"Result = {result}");
                }
                catch (Exception ex)
                {
                    //this filepath does not exist
                    string filePath = @".\LogFile\Log.txt";
                    if (File.Exists(filePath))
                    {
                        using (StreamWriter writer = new StreamWriter(filePath))
                        {
                            writer.Write(ex.GetType().Name + ex.Message + ex.StackTrace);
                            Console.WriteLine("There is a problem! Plese try later");
                        }
                    }
                    else
                    {
                        //To retain the original exception pass it as a parameter
                        //to the constructor, of the current exception
                        throw new FileNotFoundException(filePath + " Does not Exist", ex);
                    }
                }
            }
            catch (Exception ex)
            {
                //ex.Message will give the current exception message
                Console.WriteLine($"CURRENT/OUTER EXCEPTION:  {ex.Message}");
                //Check if inner exception is not null, else, you may get Null Reference Excception
                if (ex.InnerException != null)
                {
                    Console.Write($"INNER EXCEPTION:  {ex.InnerException.Message} ");                
                }
            }
        }

        static void MyClassAndInterfaces()
        {
            //Go to region Interfaces and look over 
            //IOne, ITwo and MyClassOne
            MyClassOne classOne = new MyClassOne();
            classOne.Method1();
            classOne.Method2();
            classOne.Method3();
        }

        static void ImplementingInterfaces()
        {
            //go to Interfaces region and look over MovieRating class
            List<MovieRating> movies = new List<MovieRating>();
            movies.Add(new MovieRating { Title = "Iron Man", Rating = 8 });
            movies.Add(new MovieRating { Title = "Eternals", Rating = 6 });            
            movies.Add(new MovieRating { Title = "The Wheel of Time", Rating = 5 });
            movies.Add(new MovieRating { Title = "Raised By Wolves", Rating = 10 });
            movies.Add(new MovieRating { Title = "Star Wars", Rating = 2 });
            movies.Add(new MovieRating { Title = "The Red Planet", Rating = 15 });
            movies.Add(new MovieRating { Title = "Dune", Rating = 1 });
            //here is where the 'magic' happens
            movies.Sort();

            foreach (var movie in movies)
            {
                Console.WriteLine($"{movie.Rating} - {movie.Title} - Rating {movie.Rating}");
            }
        }
    }
}
