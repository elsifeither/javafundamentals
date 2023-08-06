package finalTest;

import java.util.Scanner;

public class exercise1 {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        String input  = sc.nextLine();

        String data = sc.nextLine();
        while (!data.equals("End")) {
            String[] dataArr = data.split(" ");
            String command = dataArr[0];
            String symbol = "";
            String substring = "";

            switch (command) {
                case "Translate":
                    symbol = dataArr[1];
                    String symbolReplacement = dataArr[2];
                    input = input.replace(symbol, symbolReplacement);
                    System.out.println(input);
                    break;
                case "Includes":
                    substring = dataArr[1];
                    if (input.contains(substring)) {
                        System.out.println("True");
                    } else {
                        System.out.println("False");
                    }
                    break;
                case "Start":
                    substring = dataArr[1];
                    if (input.startsWith(substring)) {
                        System.out.println("True");
                    } else {
                        System.out.println("False");
                    }
                    break;
                case "Lowercase":
                    input = input.toLowerCase();
                    System.out.println(input);
                    break;
                case "FindIndex":
                    symbol = dataArr[1];
                    int lastIndex = 0;

                    if (input.contains(symbol)) {
                        lastIndex = input.lastIndexOf(symbol);
                    }

                    System.out.println(lastIndex);
                    break;
                case "Remove":
                    int startIndex = Integer.parseInt(dataArr[1]);
                    int count = Integer.parseInt(dataArr[2]);
                    String StringToRemove = input.substring(startIndex,startIndex+count);
                    input = input.replace(StringToRemove,"");
                    System.out.println(input);
                    break;
            }


            data = sc.nextLine();
        }




    }
}
