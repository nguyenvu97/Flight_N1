package org.tasc.booking.vnpay_Service.thread;

public class RunnableDemo extends Thread {
    private Thread thread;
    public String threadName;
    public RunnableDemo(String threadName) {

        this.threadName = threadName;
        System.out.println("Creating " + threadName);
    }
    @Override
    public void run() {
        System.out.println(getName());
        for (int i = 1; i <= 500; i++) {
            try {
                System.out.print(i + " ");
                Thread.sleep(300);
            } catch (InterruptedException ie) {
                System.out.println(ie.toString());
            }
        }
        System.out.println();
    }

//    @Override
//    public void run() {
//        try{
//            for (int i = 0 ;i <4 ; i++){
//                System.out.println("Thread: " + threadName + ", " + i);
//                // Let the thread sleep for a while.
//                Thread.sleep(50);
//            }
//
//        }catch (InterruptedException e){
//            System.out.println("Thread " + threadName + " interrupted.");
//
//        }
//        System.out.println("Thread " + threadName + " exiting.");
//
//
//    }
//    public void start() {
//        System.out.println("Starting " + threadName);
//        if (thread == null) {
//            thread = new Thread(this, threadName);
//            thread.start();
//        }
//    }

    public static void main(String[] args) throws InterruptedException {

        RunnableDemo t1 = new RunnableDemo("Thread 1");
        RunnableDemo t2 = new RunnableDemo("Thread 2");
        t1.run();

        // Main Thread phải chờ 450ms mới được tiếp tục chạy.
        // Không nhất thiết phải chờ Thread t1 kết thúc
        t1.join(10);

        t2.start();
        System.out.println("Main Thread Finished");
    }
}
