package com.openq.audit;

public class UserThreadLocal {
    private static ThreadLocal tLocal = new ThreadLocal();

    public static void set(Long userId) {
      tLocal.set(userId);
    }

    public static Long get() {
      return (Long) tLocal.get();
    }
}
