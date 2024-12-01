import java.util.Scanner;
import java.util.Arrays;

public class day6 {
    static long countWays(long time, long dist) {
        long count = 0;
        for (int i = 0; i <= time / 2; i++) {
            if (i * (time - i) > dist) {
                count++;
                if (i != time - i) {
                    count++;
                }
            }
        }
        return count;
    }

    static void part1(String[] timeStr, String[] distStr) {
        long product = 1;
        for (int i = 0; i < timeStr.length; i++) {
            long time = Long.parseLong(timeStr[i]);
            long dist = Long.parseLong(distStr[i]);
            product *= countWays(time, dist);
        }
        System.out.println(product);
    }

    static void part2(String[] timeStr, String[] distStr) {
        long time = Long.parseLong(String.join("", timeStr));
        long dist = Long.parseLong(String.join("", distStr));
        System.out.println(countWays(time, dist));
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        scanner.next();
        String[] timeStr = scanner.nextLine().trim().split("\\s+");
        scanner.next();
        String[] distStr = scanner.nextLine().trim().split("\\s+");
        part1(timeStr, distStr);
        part2(timeStr, distStr);
    }
}
