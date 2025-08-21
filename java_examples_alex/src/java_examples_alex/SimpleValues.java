package java_examples_alex;

/**
 * Demo class for simple value examples within the package.
 */
public class SimpleValues {

}

 /**
  * Base class holding a single integer value and printing it.
  */
 class Basis
 {
   protected int value1;
 
  /**
   * Creates a new Basis with the given initial value and triggers printing.
   * @param value1 the initial integer value
   */
  public Basis(int value1)
  {
     this.value1 = value1;
     print();
   }
 
   public void print()
   {
     System.out.println("Basis: value = " + value1);
   }
 }
 
 /**
  * Derived class extending {@link Basis} by adding a second value.
  */
 class Ableitung
 extends Basis
 {
   protected int value2;
 
  /**
   * Creates a new Ableitung with two values.
   * @param value1 the first value passed to the base class
   * @param value2 the second value stored in this subclass
   */
  public Ableitung(int value1, int value2)
  {
     super(value1);
     this.value2 = value2;
   }
 
   public void print()
   {
     System.out.println(
       "Ableitung value = (" + value1 + "," + value2 + ")"
     );
   }
}
