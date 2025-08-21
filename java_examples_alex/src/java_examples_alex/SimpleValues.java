package java_examples_alex;

public class SimpleValues {

}

 class Basis
 {
   protected int value1;
 
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
 
 class Ableitung
 extends Basis
 {
   protected int value2;
 
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