#!/usr/bin/env swift
import Cocoa

let size = CGSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

// Background
let bg = NSBezierPath(roundedRect: NSRect(origin: .zero, size: size), xRadius: 64, yRadius: 64)
NSColor(calibratedRed: 1.0, green: 0.98, blue: 0.85, alpha: 1.0).setFill() // warm paper yellow
bg.fill()

// Folded corner shape (top-right)
let foldSize: CGFloat = 220
let foldPath = NSBezierPath()
foldPath.move(to: NSPoint(x: size.width - foldSize, y: size.height))
foldPath.line(to: NSPoint(x: size.width, y: size.height - foldSize))
foldPath.line(to: NSPoint(x: size.width, y: size.height))
foldPath.close()
NSColor(calibratedWhite: 1.0, alpha: 0.95).setFill()
foldPath.fill()

// Slight border around the notepad
NSColor(calibratedWhite: 0, alpha: 0.08).setStroke()
bg.lineWidth = 2
bg.stroke()

// Horizontal rulings (lines)
let margin: CGFloat = 80
let left = margin
let right = size.width - margin
let topStart = size.height - 200
let lineCount = 10
let lineSpacing = CGFloat(68)
NSColor(calibratedRed: 0.2, green: 0.2, blue: 0.2, alpha: 0.12).setStroke()
for i in 0..<lineCount {
    let y = topStart - CGFloat(i) * lineSpacing
    let p = NSBezierPath()
    p.move(to: NSPoint(x: left, y: y))
    p.line(to: NSPoint(x: right, y: y))
    p.lineWidth = 8
    p.stroke()
}

// Header band (subtle)
let header = NSBezierPath(rect: NSRect(x: 0, y: size.height - 160, width: size.width, height: 160))
NSColor(calibratedRed: 1.0, green: 0.95, blue: 0.6, alpha: 0.6).setFill()
header.fill()

// A simple pencil-like accent at top-left
let pencil = NSBezierPath()
pencil.appendOval(in: NSRect(x: 92, y: size.height - 140, width: 48, height: 48))
NSColor(calibratedRed: 0.85, green: 0.15, blue: 0.15, alpha: 1.0).setFill()
pencil.fill()

// Slight shadow inside fold
let shadow = NSBezierPath()
shadow.move(to: NSPoint(x: size.width - foldSize, y: size.height))
shadow.line(to: NSPoint(x: size.width, y: size.height - foldSize))
shadow.lineWidth = 12
NSColor(calibratedWhite: 0, alpha: 0.06).setStroke()
shadow.stroke()

image.unlockFocus()

// Save as PNG
if let tiff = image.tiffRepresentation, let rep = NSBitmapImageRep(data: tiff), let png = rep.representation(using: .png, properties: [:]) {
    let url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("icon.png")
    do {
        try png.write(to: url)
        print("Wrote icon.png to \(url.path)")
        exit(0)
    } catch {
        fputs("Failed to write PNG: \(error)\n", stderr)
        exit(2)
    }
} else {
    fputs("Failed to create PNG data\n", stderr)
    exit(1)
}
