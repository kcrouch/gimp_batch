;
; Version 1.0 07.02.2012 for kkiel

; See http://gimpforums.com/thread-batch-despeckle

(define selffilename "\n- kkiel_batch_despeckle.scm")

; Batch mode wrapper
(define (kkiel_batch_despeckle file_extension destination_directory)
  (let* 
    (
      (destination_file "")
      (varFileList (cadr (file-glob (string-append "*" file_extension) 1))) ; make a list of all the files that match the file extension

      ; Adjust these values to suit
      (radius 3)         ; Filter box radius (default = 3)
      (despeckle_type 3) ; Filter type (0 = median, 1 = adaptive, 2 = recursive-median, 3 = recursive-adaptive)
      (black_level -1)   ; Black level (-1 to 255)
      (white_level 256)  ; White level (0 to 256)
      
    )
    (gimp-message-set-handler ERROR-CONSOLE)
    (if (not (file-exists? destination_directory))
      (error (string-append "Error: directory " destination_directory " doesn't exist"))
      (if (= (file-type destination_directory) FILE-TYPE-DIR)
        ()
        (error (string-append destination_directory " is not a directory"))
      )
    )
    
    ; loop through all the files in the list
    (for-each
      (lambda (filename)
        (let* (
               (image (car (gimp-file-load RUN-NONINTERACTIVE filename filename)))  ; load the image
               (drawable (car (gimp-image-flatten image)))
              )
              (gimp-message (string-append "processing-" filename))

              (plug-in-despeckle RUN-NONINTERACTIVE image drawable radius despeckle_type black_level white_level)
              
              (set! destination_file (string-append destination_directory DIR-SEPARATOR filename))
              (gimp-file-save RUN-NONINTERACTIVE image drawable destination_file destination_file)
              (gimp-image-delete image)                  ; unload the image           
        )
      )
      varFileList
    )
  )
)

;(define (script-fu-kkiel_interactive_batch_despeckle destination_directory file_extension)                     
;  (let* (
;        )
;        (kkiel_batch_despeckle file_extension destination_directory)
;  )
;)
;
;(script-fu-register "script-fu-kkiel_interactive_batch_despeckle"
;                    "Interactive Batch Despeckle..."
;                    (string-append "Interactive front end to batch despeckling " selffilename)
;                    "I did this"
;                    "GPL License"
;                    "07/02/2012"
;                    ""
;                    SF-STRING _"Destination Directory" "despeckled"
;                    SF-STRING _"Extension" ".png"
;)
;
;(script-fu-menu-register "script-fu-kkiel_interactive_batch_despeckle" "<Image>/contributed")

