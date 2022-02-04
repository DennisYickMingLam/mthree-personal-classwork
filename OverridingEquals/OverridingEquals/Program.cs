using System;

namespace OverridingEquals
{
    class Program
    {
        static void Main(string[] args)
        {
            Person p1 = new Person();
            Person p2 = new Person();

            p1.Name = "Nestor";
            p2.Name = "Nestor";
            p1.Age = 45;
            p2.Age = 45;

            Console.WriteLine(p1 == p2); //false
            Console.WriteLine(p1.Equals(p2));//true
            Console.ReadLine();
        }

        private class Person
        {
            public string Name;
            public int Age;

            public override bool Equals(object obj)
            {
                if (obj != null && obj is Person person)
                {
                    return (this.Name == person.Name)
                        && (this.Age == person.Age);
                }
                return false;
            }

            public override int GetHashCode()
            {
                return Name.GetHashCode() ^ Age.GetHashCode();
            }
        }
    }
}

