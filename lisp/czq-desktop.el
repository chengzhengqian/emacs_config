(provide `czq-desktop)

;; mainly to control the fire tablet as an secondary screen
;; add more function in future
(defun czq-fire-run-command-in-desktop (tag)
  (interactive "sf(ire_power),f(ire)s(ynergy): ")
  (cond
   ((string= tag "f") (shell-command "/home/chengzhengqian/fire_power.sh"))
   ((string= tag "fs") (shell-command "/home/chengzhengqian/set_fire_x11_env_with_synergy.sh"))
   ))
