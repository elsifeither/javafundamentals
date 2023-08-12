package DataTypesVariables;

import java.util.Scanner;

public class IntegerOperations01 {
    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);

        int number1 = Integer.parseInt(sc.nextLine());
        int number2 = Integer.parseInt(sc.nextLine());
        int number3 = Integer.parseInt(sc.nextLine());
        int number4 = Integer.parseInt(sc.nextLine());

        int result = 0;
        result = (number1+number2)/number3*number4;
        System.out.println(result);


    }
}
